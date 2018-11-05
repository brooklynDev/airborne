require 'faraday'

module Airborne
  module FaradayRequester
    def conn
      @conn ||= Faraday.new do |c|
                  c.request  :url_encoded
                  c.adapter Faraday.default_adapter
                end
    end

    def make_request(method_name, path, body = {}, headers ={}, &block)
      conn.send(method_name, path, body) do |req|
        conn.url_prefix = base_url
        req.path = path
        req.headers.merge!(headers)
        yield req, conn if block_given?
        req.headers.merge!(conn.headers)
      end
    end

    private
      def base_url
        Airborne.configuration.base_url
      end
  end
end

module FaradayResponse
  def code
    status
  end
end

Faraday::Response.send(:include, FaradayResponse)
