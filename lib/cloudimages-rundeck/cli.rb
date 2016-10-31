# Encoding: UTF-8
# rubocop: disable LineLength, MethodLength, AbcSize
#
# Gem Name:: cloudimages-rundeck
# CloudImagesRunDeck:: CLI
#
# Copyright (C) 2016 Brian Dwyer - Intelligent Digital Services
#
# All rights reserved - Do Not Redistribute
#

require 'mixlib/cli'
require 'cloudimages-rundeck/config'
require 'cloudimages-rundeck/util'

module CloudImagesRunDeck
  #
  # => CloudImages-RunDeck Launcher
  #
  module CLI
    extend self
    #
    # => Options Parser
    #
    class Options
      # => Mix-In the CLI Option Parser
      include Mixlib::CLI

      option :do_api_key,
             short: '-d KEY',
             long: '--do-api-key KEY',
             description: 'DigitalOcean API Key'

      option :cache_timeout,
             short: '-t CACHE_TIMEOUT',
             long: '--timeout CACHE_TIMEOUT',
             description: 'Sets the cache timeout in seconds for API query response data.'

      option :config_file,
             short: '-c CONFIG',
             long: '--config CONFIG',
             description: 'The configuration file to use, as opposed to command-line parameters (optional)'

      option :bind,
             short: '-b HOST',
             long: '--bind HOST',
             description: "Listen on Interface or IP (Default: #{Config.bind})"

      option :port,
             short: '-p PORT',
             long: '--port PORT',
             description: "The port to run on. (Default: #{Config.port})"

      option :environment,
             short: '-e ENV',
             long: '--env ENV',
             description: "Sets the environment for cloudimages-rundeck to execute under. Use 'development' for more logging. (Default: #{Config.environment})"
    end

    # => Launch the Application
    def run(argv = ARGV)
      # => Parse CLI Configuration
      cli = Options.new
      cli.parse_options(argv)

      # => Parse JSON Config File (If Specified and Exists)
      json_config = Util.parse_json_config(cli.config[:config_file] || Config.config_file)

      # => Grab the Default Values
      default = Config.options

      # => Merge Configuration (CLI Wins)
      config = [default, json_config, cli.config].compact.reduce(:merge)

      # => Apply Configuration
      Config.setup do |cfg|
        cfg.config_file         = config[:config_file]
        cfg.cache_timeout       = config[:cache_timeout].to_i
        cfg.bind                = config[:bind]
        cfg.port                = config[:port]
        cfg.environment         = config[:environment].to_sym.downcase
        cfg.do_api_key          = config[:do_api_key]
      end

      # => Launch the API
      API.run!
    end
  end
end
