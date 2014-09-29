require 'coveralls'
Coveralls.wear!
require 'airborne'
require 'stub_helper'

Airborne.configure do |config|
  config.base_url = 'http://www.example.com'
  config.include StubHelper
end

