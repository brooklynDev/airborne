require 'airborne/rspec_settings'
require 'airborne/optional_hash_type_expectations'
require 'airborne/path_matcher'
require 'airborne/request_expectations'
require 'airborne/rest_client_requester'
require 'airborne/rack_test_requester'
require 'airborne/faraday_requester'
require 'airborne/base'


module Airborne
  class << self
    def configuration
      RSpec.configuration
    end

    def configure
      RSpec.configure do |config|
        yield config
      end
    end
  end
end

RSpec.configure do |config|
  config.include Airborne::Base
end
