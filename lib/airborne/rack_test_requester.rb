require 'rack/test'

module Airborne
  module RackTestRequester
    def make_request(method, url, options = {})
      browser = Rack::Test::Session.new(Rack::MockSession.new(Airborne.configuration.rack_app))
      browser.send(method, url, options[:body] || {}, options[:headers] || {})
      browser.last_response
    end
  end
end