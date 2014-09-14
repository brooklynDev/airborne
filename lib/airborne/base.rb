require 'rest_client'
require 'json'
require 'active_support'
require 'active_support/core_ext'

module Airborne
	include RequestExpectations

	def self.configure
		RSpec.configure do |config|
			yield config
		end
	end

	def self.configuration
		RSpec.configuration
	end

	def get(url)
		res = RestClient.get(get_url(url))
		get_response(res)
	end

	def post(url, post_body = {} )
		res = RestClient.post(get_url(url), post_body)
		get_response(res)
	end
	def patch(url, patch_body = {} )
		res = RestClient.patch(get_url(url), patch_body)
		get_response(res)
	end
	
	def put(url, put_body = {} )
		res = RestClient.put(get_url(url), put_body)
		get_response(res)
	end
	
	def delete(url)
		res = RestClient.delete(get_url(url))
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
		base = Airborne.configuration.base_url ||= ""
		base + url
	end

	def get_response(res)
		@response = res
		@headers = res.headers.deep_symbolize_keys!
		@body = JSON.parse(res.body)
		@body.deep_symbolize_keys!
	end
end