# Encoding: UTF-8
# rubocop: disable LineLength
#
# Gem Name:: cloudimages-rundeck
# DeployInfo:: Util
#
# Copyright (C) 2016 Brian Dwyer - Intelligent Digital Services
#
# All rights reserved - Do Not Redistribute
#

require 'json'

module CloudImagesRunDeck
  # => Utility Methods
  module Util
    extend self

    ########################
    # =>    File I/O    <= #
    ########################

    # => Define JSON Parser
    def parse_json_config(file = nil, symbolize = true)
      return unless file && ::File.exist?(file.to_s)
      begin
        ::JSON.parse(::File.read(file.to_s), symbolize_names: symbolize)
      rescue JSON::ParserError
        return
      end
    end

    # => Define JSON Writer
    def write_json_config(file, object)
      return unless file && object
      begin
        File.open(file, 'w') { |f| f.write(JSON.pretty_generate(object)) }
      end
    end

    # => Check if a string is an existing file, and return it's content
    def filestring(file, size = 8192)
      return unless file
      return file unless file.is_a?(String) && File.file?(file) && File.size(file) <= size
      File.read(file)
    end

    #############################
    # =>    Serialization    <= #
    #############################

    def serialize(response)
      # => Serialize Object into JSON Array
      JSON.pretty_generate(response.map(&:name).sort_by(&:downcase))
    end

    def serialize_csv(csv)
      # => Serialize a CSV String into an Array
      return unless csv && csv.is_a?(String)
      csv.split(',')
    end

    def serialize_revisions(branches, tags)
      # => Serialize Branches/Tags into JSON Array
      # => Branches = String, Tags = Key/Value
      branches = branches.map(&:name).sort_by(&:downcase)
      tags = tags.map(&:name).sort_by(&:downcase).reverse.map { |tag| { name: "Tag: #{tag}", value: tag } }
      JSON.pretty_generate(branches + tags)
    end
  end
end
