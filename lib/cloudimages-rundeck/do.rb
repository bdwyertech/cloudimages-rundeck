# Encoding: UTF-8
# rubocop: disable LineLength
#
# Gem Name:: cloudimages-rundeck
# CloudImagesRunDeck:: Do
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
      DropletKit::Client.new(access_token: Util.filestring(Config.do_api_key))
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
    def list_images # rubocop:disable AbcSize, MethodLength
      list = images
      return list.message if list.is_a?(DropletKit::Error)
      list = list.collect do |image|
        {
          'name' => image['name'] || image['message'],
          'value' => image['id'].to_s
        }
      end
      filter = Util.serialize_csv(Config.query_params['filter'])
      return list.select { |i| filter.any? { |f| i['name'] =~ /#{f}/i } } if filter
      list
    end

    #
    # => Image Cleanup
    #
    def cleanup_images # rubocop:disable AbcSize
      # => Ensure we have a Filter
      return unless Config.query_params['filter'] && Config.query_params['keep'].to_i >= 1

      # => Grab the Images & Sort by ImageID
      # => NOTE: If ImageID's aren't reliable, try DateTime.parse(hsh['name']) for sorting
      cleanup = list_images.sort_by { |img| img['value'] }.reverse.drop(Config.query_params['keep'].to_i)

      return unless cleanup.is_a?(Array)

      # => Delete the Images
      cleanup.each do |img|
        do_client.images.delete(id: img['value'])
      end
    end
  end
end
