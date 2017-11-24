require 'faraday'

module Airborne
  class FaradayRequester
    def conn
      @conn ||= Faraday.new
    end

    def make_request(method_name, path, body = {}, headers ={}, &block)
      conn.send(method_name, path, body) do |req|
        conn.url_prefix = base_url
        req.path = path
        req.headers = headers
        yield req, conn if block_given?
      end
    end

    private
      def base_url
        Airborne.configuration.base_url
      end
  end
end
