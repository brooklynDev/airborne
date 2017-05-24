require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      params = base_params.merge(
        method: method,
        url: get_url(url),
        headers: base_headers.merge(options[:headers] || {}))

      if include_body?(method)
        request_body = options[:body].nil? ? '' : options[:body]
        request_body = request_body.to_json if options[:body].is_a?(Hash)
        params[:payload] = request_body
      end

      RestClient::Request.execute(params)
    rescue RestClient::Exception => e
      e.response
    end

    private

    def include_body?(method)
      [:post, :patch, :put].include?(method)
    end

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end

    def base_params
      Airborne.configuration.rest_client_options || {}
    end
  end
end
