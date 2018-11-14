require 'rack/test'

module Airborne
  module RackTestRequester
    def make_request(method, url, body = {}, headers = {}, &block)
      headers = (Airborne.configuration.headers || {}).merge(headers || {})
      browser = Rack::Test::Session.new(Rack::MockSession.new(Airborne.configuration.rack_app))
      headers.each { |name, value| browser.header(name, value) }
      browser.send(method, url, body || {}, headers)
      Rack::MockResponse.class_eval do
        alias_method :code, :status
      end
      browser.last_response
    end
  end
end
