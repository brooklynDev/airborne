require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, body, headers, &block)
      headers = base_headers.merge(headers || {})
      res = if method == :post || method == :patch || method == :put
        begin
          request_body = body || ''
          request_body = request_body.to_json if request_body.is_a?(Hash)
          RestClient.send(method, get_url(url), request_body, headers)
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
      res
    end

    private

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end
  end
end
