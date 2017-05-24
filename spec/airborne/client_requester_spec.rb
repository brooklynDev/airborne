require 'spec_helper'

describe 'client requester' do
  after do
    Airborne.configure { |config| config.headers =  {} }
  end

  it 'should set :content_type to :json by default' do
    stub_request(:get, 'http://www.example.com/foo')
      .with(headers: { 'Content-Type' => 'application/json' })

    get '/foo'
  end

  it 'should override headers with option[:headers]' do
    stub_request(:get, 'http://www.example.com/foo')
      .with(headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })

    get '/foo', { content_type: 'application/x-www-form-urlencoded' }
  end

  it 'should override headers with airborne config headers' do
    Airborne.configure { |config| config.headers = { content_type: 'text/plain' } }

    stub_request(:get, 'http://www.example.com/foo')
      .with(headers: { 'Content-Type' => 'text/plain' })

    get '/foo'
  end
end
