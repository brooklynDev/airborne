require 'spec_helper'
require 'webmock/rspec'

describe 'post' do
  it 'should allow testing on post requests' do
    mock_post('simple_post')
    post '/simple_post', {}
    expect_json_types(status: :string, someNumber: :int)
  end

  it 'should allow testing on post requests' do
    url = 'http://www.example.com/simple_post'
    stub_request(:post, url)
    post '/simple_post', 'hello', content_type: 'text/plain'
    expect(WebMock).to have_requested(:post, url).with(body: 'hello', headers: { 'Content-Type' => 'text/plain' })
  end

  it 'should allow testing on post requests with IO body' do
    url = 'http://www.example.com/simple_post'
    stub_request(:post, url)
    post '/simple_post', StringIO.new('hello'), content_type: 'application/octet-stream'
    expect(WebMock).to have_requested(:post, url).with(body: 'hello', headers: { 'Content-Type' => 'application/octet-stream' })
  end
end
