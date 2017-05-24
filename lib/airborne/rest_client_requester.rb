require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = base_headers.merge(options[:headers] || {})
      res = if method == :post || method == :patch || method == :put
        begin
          RestClient.send(method, get_url(url), options[:body] || '', headers)
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
