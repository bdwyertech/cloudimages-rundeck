# Encoding: UTF-8
# rubocop: disable LineLength
#
# Gem Name:: cloudimages-rundeck
# DeployInfo:: Do
#
# Copyright (C) 2016 Brian Dwyer - Intelligent Digital Services
#
# All rights reserved - Do Not Redistribute
#

require 'cloudimages-rundeck/config'
require 'droplet_kit'

module CloudImagesRunDeck
  # => This is the Do Module. It interacts with DigitalOcean resources.
  module Do
    extend self

    def do_client
      # => Instantiate a new DigitalOcean Client
      DropletKit::Client.new(access_token: Config.do_api_key)
    end

    #
    # => Grab the Private Images from DigitalOcean
    #
    def images
      do_client.images.all.select do |image|
        image.public == false && image.type.casecmp('snapshot').zero?
      end.sort_by(&:id).reverse
    rescue DropletKit::Error => e
      e
    end

    #
    # => Custom-Tailor for Resource-JSON & Optionally Filter by Image Name
    #
    def list_images # rubocop:disable MethodLength
      list = images
      return list.message if list.is_a?(DropletKit::Error)
      list = list.collect do |image|
        {
          'name' => image['name'] || image['message'],
          'value' => image['id']
        }
      end
      filter = Util.serialize_csv(Config.query_params['filter'])
      return list.select { |i| filter.any? { |f| i['name'] =~ /#{f}/i } } if filter
      list
    end
  end
end
