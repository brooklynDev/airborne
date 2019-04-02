require 'spec_helper'

describe 'client requester' do
  before do
    allow(RestClient::Request).to receive(:execute)
    RSpec::Mocks.space.proxy_for(self).remove_stub_if_present(:get)
  end

  after do
    allow(RestClient::Request).to receive(:execute).and_call_original
    Airborne.configure { |config| config.headers =  {} }
  end

  it 'should set :content_type to :json by default' do
    get '/foo'

    expect(RestClient::Request).to have_received(:execute).with(
      method: :get,
      url: 'http://www.example.com/foo',
      headers: { content_type: :json }
    )
  end

  it 'should override headers with option[:headers]' do
    get '/foo', { content_type: 'application/x-www-form-urlencoded' }

    expect(RestClient::Request).to have_received(:execute).with(
      method: :get,
      url: 'http://www.example.com/foo',
      headers: { content_type: 'application/x-www-form-urlencoded' }
    )
  end

  it 'should override headers with airborne config headers' do
    Airborne.configure { |config| config.headers = { content_type: 'text/plain' } }

    get '/foo'

    expect(RestClient::Request).to have_received(:execute).with(
      method: :get,
      url: 'http://www.example.com/foo',
      headers: { content_type: 'text/plain' }
    )
  end

  it 'should serialize body to json when :content_type is (default) :json' do
    post '/foo', { test: 'serialized' }

    expect(RestClient::Request).to have_received(:execute).with(
      method: :post,
      url: 'http://www.example.com/foo',
      payload: { test: 'serialized' }.to_json,
      headers: { content_type: :json }
    )
  end

  it 'should serialize body to json when :content_type is any enhanced JSON content type' do
    post '/foo', { test: 'serialized' }, { content_type: 'application/vnd.airborne.2+json' }

    expect(RestClient::Request).to have_received(:execute).with(
      method: :post,
      url: 'http://www.example.com/foo',
      payload: { test: 'serialized' }.to_json,
      headers: { content_type: 'application/vnd.airborne.2+json' }
    )
  end

  it 'should not serialize body to json when :content_type does not match JSON' do
    post '/foo', { test: 'not serialized' }, { content_type: 'text/plain' }

    expect(RestClient::Request).to have_received(:execute).with(
      method: :post,
      url: 'http://www.example.com/foo',
      payload: { test: 'not serialized' },
      headers: { content_type: 'text/plain' }
    )
  end
end
