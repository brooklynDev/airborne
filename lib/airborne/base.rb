require 'rest_client'
require 'json'

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
		headers = options[:headers] || {}
		base_headers = Airborne.configuration.headers || {}
		headers = base_headers.merge(headers)
		res = if method == :post || method == :patch || method == :put
			begin
				RestClient.send(method, get_url(url), options[:body], headers)
			rescue RestClient::Exception => e
				e.response
			end
		else
			begin
				RestClient.send(method, get_url(url), headers)
			rescue RestClient::Exception => e
				e.response
			end

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
		@headers = res.headers
		begin
			@json_body = JSON.parse(res.body, symbolize_names: true) unless res.body == ""
		rescue
		end
	end
end
