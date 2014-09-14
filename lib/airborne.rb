require 'rest_client'
require 'json'
require 'request_expectations'
require 'active_support'
require 'active_support/core_ext'

module AirBorne
	class Configuration
		attr_accessor :base_url
	end

	def self.configure
		config = Configuration.new
		yield config
		@@base_url = config.base_url
	end

	include RequestExpectations

	def get(url)
		@response = RestClient.get(@@base_url + url)
		@headers = @response.headers.deep_symbolize_keys!
		@body = JSON.parse(@response.body)
		@body.deep_symbolize_keys!
	end

	def post(url, body)
	end
	def response
		@response
	end
	def headers
		@headers
	end
	def body
		@body
	end

end

RSpec.configure do |config|
	config.include AirBorne
end


