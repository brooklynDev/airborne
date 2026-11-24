require 'json'
require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'airborne/response_headers'
require 'airborne/request_methods'

module Airborne
  class InvalidJsonError < StandardError; end

  include RequestExpectations

  def self.configure
    RSpec.configure do |config|
      yield config
    end
  end

  def self.included(base)
    # Rails request and controller specs own their request helpers and response.
    if defined?(RSpec::Rails::RequestExampleGroup)
      return if base < RSpec::Rails::RequestExampleGroup || base < RSpec::Rails::ControllerExampleGroup
    end

    base.send(:include, RequestMethods)
    if !Airborne.configuration.requester_module.nil?
      base.send(:include, Airborne.configuration.requester_module)
    elsif !Airborne.configuration.rack_app.nil?
      base.send(:include, RackTestRequester)
    else
      base.send(:include, RestClientRequester)
    end
  end

  def self.configuration
    RSpec.configuration
  end

  def headers
    ResponseHeaders.new(response.headers.to_h)
  end

  def body
    response.body
  end

  def json_body
    JSON.parse(response.body, symbolize_names: true) rescue fail InvalidJsonError, 'Api request returned invalid json'
  end

  private

  def get_url(url)
    base = Airborne.configuration.base_url || ''
    base + url
  end

  def base_verify_ssl
    Airborne.configuration.verify_ssl || false
  end
end
