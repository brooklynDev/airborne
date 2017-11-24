require 'coveralls'
Coveralls.wear!
require 'airborne'
require 'stub_helper'
require 'pry'

Airborne.configure do |config|
  config.base_url = 'http://www.example.com'
  config.include StubHelper
  config.use_faraday = false
end

ExpectationNotMetError = RSpec::Expectations::ExpectationNotMetError
ExpectationError       = Airborne::ExpectationError
InvalidJsonError       = Airborne::Base::InvalidJsonError
PathError              = Airborne::PathError
