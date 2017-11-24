require 'json'
require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'

module Airborne
  module Base
    class InvalidJsonError < StandardError; end

    include RequestExpectations

    attr_reader :response, :headers, :body

    def self.included(base)
      if !Airborne.configuration.requester_module.nil?
        base.send(:include, Airborne.configuration.requester_module)
      elsif !Airborne.configuration.rack_app.nil?
        base.send(:include, RackTestRequester)
      else
        base.send(:include, RestClientRequester)
      end
    end

    def get(path, body = nil, headers = nil, &block)
      @response = make_request(:get, path, body, headers, &block)
    end

    def post(path, post_body = nil, headers = nil, &block)
      @response = make_request(:post, path, post_body, headers, &block)
    end

    def patch(path, patch_body = nil, headers = nil, &block)
      @response = make_request(:patch, path, patch_body, headers, &block)
    end

    def put(path, put_body = nil, headers = nil, &block)
      @response = make_request(:put, path, put_body, headers, &block)
    end

    def delete(path, delete_body = nil, headers = nil, &block)
      @response = make_request(:delete, path, delete_body, headers, &block)
    end

    def head(path, body = nil, headers = nil, &block)
      @response = make_request(:head, path, body, headers, &block)
    end

    def options(path, body = nil, headers = nil, &block)
      @response = make_request(:options, path, body, headers, &block)
    end

    def response
      @response
    end

    def headers
      HashWithIndifferentAccess.new(response.headers)
    end

    def body
      response.body
    end

    def json_body
      JSON.parse(response.body, symbolize_names: true) rescue fail InvalidJsonError, 'Api request returned invalid json'
    end

    private

    def get_url(url)
      base = Airborne.configuration.base_url || ''
      base + url
    end
  end
end
