require 'rest_client'
require 'json'
require 'request_expectations'
require 'active_support'
require 'active_support/core_ext'

module AirBorne
	include RequestExpectations

	def self.configure
		RSpec.configure do |config|
			class << config
				attr_accessor :base_url		
			end
			yield config
			@@base_url = config.base_url
		end
	end

	def get(url)
		res = RestClient.get(get_url(url))
		get_response(res)
	end

	def post(url, post_body = {} )
		res = RestClient.post(get_url(url), post_body)
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