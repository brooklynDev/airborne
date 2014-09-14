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
		res = RestClient.get(get_url(url))
		get_response(res)
	end

	def post(url, body)
		res = RestClient.post(get_url(url), body)
		get_response(res)
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
	
	private

	def get_url(url)
		base = @@base_url ||= ""
		base + url
	end

	def get_response(res)
		@response = res
		@headers = res.headers.deep_symbolize_keys!
		@body = JSON.parse(res.body)
		@body.deep_symbolize_keys!
	end

end

RSpec.configure do |config|
	config.include AirBorne
end