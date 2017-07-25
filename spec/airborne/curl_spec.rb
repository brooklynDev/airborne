require 'spec_helper'

describe 'curl command spec' do
  it 'when a GET request is made curl should provide correct equivalent' do
    mock_get('simple_get')
    get '/simple_get'

    expect(curl).to eq('curl -v -d \'\' -XGET -H \"Content-Type:\ json\" http://www.example.com/simple_get')
  end

  it 'when a POST request is made curl should provide correct equivalent' do
    mock_post('simple_post')
    body = { test: "value", bool: true }
    post '/simple_post', body, { x_header: "is it?" }

    expect(curl).to eq('curl -v -d \{\"test\":\"value\",\"bool\":true\} -XPOST -H \"Content-Type:\ json\" -H \"X-Header:\ is\ it\?\" http://www.example.com/simple_post')
  end
end
