require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = (options[:headers] || {}).merge({content_type: :json})
      base_headers = Airborne.configuration.headers || {}
      headers = base_headers.merge(headers)
      res = if method == :post || method == :patch || method == :put
        begin
          options[:body] = JSON.parse(options[:body])
        resuce JSON::ParseError
          options[:body].nil? ? "" : options[:body]
        end
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
      res
    end
  end
end