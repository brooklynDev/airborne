require 'airborne'
require 'webmock/rspec'

AirBorne.configure do |config|
	config.base_url = 'http://www.example.com'
end

def mock_get(url)
	stub_request(:get, 'http://www.example.com/' + url)
		.to_return(headers: {'Content-Type' => 'text/json'}, body: IO.read(File.join('spec/test_responses', url + ".json")))
end