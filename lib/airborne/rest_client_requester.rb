# frozen_string_literal: true

require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = base_headers.merge(options[:headers] || {})

      RestClient::Request.execute(
        method: method,
        url: get_url(url),
        payload: request_body(method, headers, options),
        headers: headers,
        verify_ssl: options.fetch(:verify_ssl, true)
      ) { |response, _request, _result| response }
    rescue RestClient::Exception => e
      e.response || e.original_exception
    end

    private

    def request_body(method, headers, options)
      return unless [:post, :patch, :put, :delete].include?(method)

      request_body = options[:body].nil? || empty?(options[:body]) ? '' : options[:body]
      request_body = request_body.to_json if json_request?(headers) && !empty?(request_body)
      request_body
    end

    def json_request?(headers)
      header = headers.fetch(:content_type)
      header == :json || %r{application/([a-zA-Z0-9._-]*\+?)json} =~ header
    end

    def empty?(body)
      return body.empty? if body.respond_to?(:empty?)

      false
    end

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end
  end
end
