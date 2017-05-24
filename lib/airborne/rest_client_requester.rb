require 'rest_client'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      rest_client_params = {
        method: method,
        url: get_url(url),
        headers: base_headers.merge(options[:headers] || {})
      }
      rest_client_params.merge!(options[:advanced_options]) unless options[:advanced_options].nil?

      if method == :post || method == :patch || method == :put
        rest_client_params[:payload] = if options[:body].nil?
          ''
        elsif options[:body].is_a?(Hash)
          options[:body].to_json
        else
          options[:body]
        end
      end

      begin
        RestClient::Request.execute(rest_client_params)
      rescue RestClient::Exception => e
        e.response
      end
    end

    private

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end
  end
end
