require 'rack/response'

module Airborne
  class Response < Struct.new(:raw)
    include Rack::Response::Helpers

    alias_method :success?, :successful?
    alias_method :missing?, :not_found?
    alias_method :error?, :server_error?

    def status
      raw.code
    end

    def method_missing(name, *args, &block)
      raw.send(name, *args, &block)
    end
  end
end
