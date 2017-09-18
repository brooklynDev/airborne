require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = base_headers.merge(options[:headers] || {})
      res = if method == :post || method == :patch || method == :put
        begin
          request_body = options[:body].nil? ? '' : options[:body]
          request_body = request_body.to_json if is_json_request(headers)
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

    def is_json_request(headers)
      header = headers.fetch(:content_type)
      header == :json || /application\/([a-zA-Z0-9\.\_\-]*\+?)json/ =~ header
    end

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end
  end
end
