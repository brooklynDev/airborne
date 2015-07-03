require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = { content_type: :json }.merge(options[:headers] || {})
      base_headers = Airborne.configuration.headers || {}
      headers = base_headers.merge(headers)
      res = if method == :post || method == :patch || method == :put
              begin
                request_body = options[:body].nil? ? '' : options[:body]
                request_body = request_body.to_json if options[:body].is_a?(Hash)
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
  end
end
