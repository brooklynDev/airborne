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
		@body = JSON.parse(@response.body)
		@body.deep_symbolize_keys!
	end

	def post(url, body)
	end
	def response
		@response
	end

	def body
		@body
	end

	private

	def get_headers
	end

end

RSpec.configure do |config|
	config.include AirBorne
end


