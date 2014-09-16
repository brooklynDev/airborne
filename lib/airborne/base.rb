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

	def get(url, headers = nil)
		make_request(:get, url, {headers: headers})
	end

	def post(url, post_body = nil, headers = nil)
		make_request(:post, url, {body: post_body, headers: headers})
	end

	def patch(url, patch_body = nil, headers = nil )
		make_request(:patch, url, {body: patch_body, headers: headers})
	end

	def put(url, put_body = nil, headers = nil )
		make_request(:put, url, {body: put_body, headers: headers})
	end

	def delete(url, headers = nil)
		make_request(:delete, url, {headers: headers})
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

	def json_body
		@json_body
	end

	private

	def make_request(method, url, options = {})
		res = unless options[:body].nil?
			RestClient.send(method, get_url(url), options[:body], options[:headers] || Airborne.configuration.headers || {})
		else
			RestClient.send(method, get_url(url), options[:headers] || Airborne.configuration.headers || {})
		end
		set_response(res)
	end

	def get_url(url)
		base = Airborne.configuration.base_url || ""
		base + url
	end

	def set_response(res)
		@response = res
		@body = res.body
		@headers = res.headers.deep_symbolize_keys!
		unless res.body == ""
			@json_body = JSON.parse(res.body)
			if @json_body.class == Array
				hash = {res: @json_body}.deep_symbolize_keys
				@json_body = hash[:res]
			else 
				@json_body = @json_body.deep_symbolize_keys
			end
		end
	end
end
