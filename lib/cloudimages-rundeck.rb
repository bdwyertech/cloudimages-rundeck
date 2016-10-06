# encoding: UTF-8
# rubocop: disable LineLength
# Cloud Image Information Provider for RunDeck
# Brian Dwyer - Intelligent Digital Services - 10/5/16

require 'cloudimages-rundeck/cli'
require 'cloudimages-rundeck/config'
require 'cloudimages-rundeck/util'
require 'cloudimages-rundeck/version'

# => Cloud Image Information API
module CloudImagesRunDeck
  # => The Sinatra API should be Lazily-Loaded, such that the CLI arguments and/or configuration files are respected
  autoload :API, 'cloudimages-rundeck/api'
end
