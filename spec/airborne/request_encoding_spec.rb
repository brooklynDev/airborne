require 'spec_helper'
require 'tempfile'

describe 'request encoding' do
  around do |example|
    previous_headers = Airborne.configuration.headers
    Airborne.configuration.headers = {}
    example.run
  ensure
    Airborne.configuration.headers = previous_headers
  end

  ['Content-Type', 'content-type', 'CONTENT_TYPE', :content_type].each do |name|
    it "encodes form data using the #{name.inspect} header spelling" do
      stub_request(:post, 'http://www.example.com/login')
        .with(body: { email: 'user', password: 'pass' },
              headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
        .to_return(body: '{}')

      post '/login', { email: 'user', password: 'pass' }, name => 'application/x-www-form-urlencoded'

      expect_status(200)
    end
  end

  it 'lets request headers override equivalent global header names' do
    Airborne.configuration.headers = { 'Content-Type' => 'text/plain', 'X-Token' => 'default' }
    stub_request(:post, 'http://www.example.com/items')
      .with(body: '{"name":"test"}', headers: { 'Content-Type' => 'application/problem+json', 'X-Token' => 'override' })
      .to_return(body: '{}')

    post '/items', { name: 'test' }, content_type: 'application/problem+json', x_token: 'override'

    expect_status(200)
  end

  it 'uses a globally configured HTTP Content-Type for form encoding' do
    Airborne.configuration.headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    stub_request(:put, 'http://www.example.com/items')
      .with(body: { name: 'test' }, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
      .to_return(body: '{}')

    put '/items', { name: 'test' }

    expect_status(200)
  end

  it 'recognizes case-insensitive JSON media types with parameters' do
    stub_request(:patch, 'http://www.example.com/items')
      .with(body: '{"name":"test"}', headers: { 'Content-Type' => 'Application/Problem+JSON; charset=utf-8' })
      .to_return(body: '{}')

    patch '/items', { name: 'test' }, 'Content-Type' => 'Application/Problem+JSON; charset=utf-8'

    expect_status(200)
  end

  it 'does not JSON-encode a binary multipart upload' do
    Tempfile.create(['airborne-upload', '.bin']) do |file|
      file.binmode
      file.write("\xFF\x00\xFE".b)
      file.rewind
      stub_request(:post, 'http://www.example.com/upload').with do |request|
        request.headers['Content-Type'].start_with?('multipart/form-data; boundary=') &&
          request.body.b.include?("\xFF\x00\xFE".b)
      end.to_return(body: '{}')

      post '/upload', { file: file }, 'Content-Type' => 'multipart/form-data'

      expect_status(200)
    end
  end
end
