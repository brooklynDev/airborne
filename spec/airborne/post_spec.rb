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
    post '/simple_post', 'hello', content_type: 'text/plain', 'Authorization' => basic_auth('shreyas', 'agarwal')
    expect(WebMock).to have_requested(:post, url).with(body: 'hello', headers: { 'Content-Type' => 'text/plain', 'Authorization' => 'Basic c2hyZXlhczphZ2Fyd2Fs' })
  end
end
