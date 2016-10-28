# Encoding: UTF-8
# rubocop: disable LineLength
#
# Gem Name:: cloudimages-rundeck
# DeployInfo:: API
#
# Copyright (C) 2016 Brian Dwyer - Intelligent Digital Services
#
# All rights reserved - Do Not Redistribute
#

# => NOTE: Anything other than a STATUS 200 will trigger an error in the RunDeck plugin due to a hardcode in org.boon.HTTP

require 'sinatra/base'
require 'sinatra/namespace'
require 'json'
require 'rack/cache'
require 'cloudimages-rundeck/do'
require 'cloudimages-rundeck/config'

# => Cloud Image Information Provider for RunDeck
module CloudImagesRunDeck
  # => HTTP API
  class API < Sinatra::Base
    #######################
    # =>    Sinatra    <= #
    #######################

    # => Configure Sinatra
    enable :logging, :static, :raise_errors # => disable :dump_errors, :show_exceptions
    set :port, Config.port || 8080
    set :bind, Config.bind || 'localhost'
    set :environment, Config.environment || :production

    # => Enable NameSpace Support
    register Sinatra::Namespace

    if development?
      require 'sinatra/reloader'
      register Sinatra::Reloader
    end

    use Rack::Cache do
      set :verbose, true
      set :metastore,   'file:' + File.join(Dir.tmpdir, 'rack', 'meta')
      set :entitystore, 'file:' + File.join(Dir.tmpdir, 'rack', 'body')
    end

    ########################
    # =>    JSON API    <= #
    ########################

    # => Current Configuration & Healthcheck Endpoint
    get '/config' do
      content_type 'application/json'
      JSON.pretty_generate(
        [
          CloudImagesRunDeck.inspect + ' is up and running!',
          'Author: ' + Config.author,
          'Environment: ' + Config.environment.to_s,
          'Root: ' + Config.root.to_s,
          'Config File: ' + (Config.config_file if File.exist?(Config.config_file)).to_s,
          'Params: ' + params.inspect,
          'Cache Timeout: ' + Config.cache_timeout.to_s,
          'BRIAN IS COOooooooL',
          { AppConfig: Config.options },
          { 'Sinatra Info' => env }
        ].compact
      )
    end

    ########################
    # =>    JSON API    <= #
    ########################

    namespace '/images/v1' do
      # => Define our common namespace parameters
      before do
        # => This is a JSON API
        content_type 'application/json'

        # => Make the Params Globally Accessible
        Config.define_setting :query_params, params
      end

      # => Clean Up
      after do
        # => Reset the API Client to Default Values
        # => Notifier.reset!
      end

      # => List Images
      get '/list' do
        cache_control :public, max_age: Config.cache_timeout

        Do.list_images.to_json
      end

      # => Cleanup Images
      post '/cleanup' do
        Do.cleanup_images.to_json
      end
    end
  end
end
