require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = base_headers.merge(options[:headers] || {})
      verify_ssl = options.fetch(:verify_ssl, true)
      res = if method == :post || method == :patch || method == :put || method == :delete
        begin
          request_body = options[:body].nil? ? '' : options[:body]
          request_body = request_body.to_json if is_json_request(headers)
          RestClient::Request.execute(
            method: method,
            url: get_url(url),
            payload: request_body,
            headers: headers,
            verify_ssl: verify_ssl
          ) { |response, request, result| response }
        rescue RestClient::Exception => e
          e.response
        end
      else
        begin
          RestClient::Request.execute(
            method: method,
            url: get_url(url),
            headers: headers,
            verify_ssl: verify_ssl
          ) { |response, request, result| response }
        rescue RestClient::Exception => e
          e.response
        end
      end
      res
    end

    private

    def is_json_request(headers)
      header = headers.fetch(:content_type)
      header == :json || /application\/([a-zA-Z0-9\.\_\-]*\+?)json/ =~ header
    end

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end
  end
end
