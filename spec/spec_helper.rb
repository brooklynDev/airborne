require 'airborne'
require 'stub_helper'

AirBorne.configure do |config|
	config.base_url = 'http://www.example.com'
	config.include StubHelper
end

