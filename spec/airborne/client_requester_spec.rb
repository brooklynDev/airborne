require 'spec_helper'

describe 'client requester' do
  before do
    allow(RestClient::Request).to receive(:execute)
    RSpec::Mocks.space.proxy_for(self).remove_stub_if_present(:get)
  end

  after do
    allow(RestClient::Request).to receive(:execute).and_call_original
    Airborne.configure { |config| config.headers = {} }
    Airborne.configure { |config| config.verify_ssl = true }
  end

  it 'should set :content_type to :json by default' do
    get '/foo'

    expect(RestClient::Request).to have_received(:execute).with(
      method: :get,
      url: 'http://www.example.com/foo',
      headers: { content_type: :json },
      verify_ssl: true
    )
  end

  it 'should override headers with option[:headers]' do
    get '/foo', { content_type: 'application/x-www-form-urlencoded' }

    expect(RestClient::Request).to have_received(:execute).with(
      method: :get,
      url: 'http://www.example.com/foo',
      headers: { content_type: 'application/x-www-form-urlencoded' },
      verify_ssl: true
    )
  end

  it 'should override headers with airborne config headers' do
    Airborne.configure { |config| config.headers = { content_type: 'text/plain' } }

    get '/foo'

    expect(RestClient::Request).to have_received(:execute).with(
      method: :get,
      url: 'http://www.example.com/foo',
      headers: { content_type: 'text/plain' },
      verify_ssl: true
    )
  end

  it 'should serialize body to json when :content_type is (default) :json' do
    post '/foo', { test: 'serialized' }

    expect(RestClient::Request).to have_received(:execute).with(
      method: :post,
      url: 'http://www.example.com/foo',
      payload: { test: 'serialized' }.to_json,
      headers: { content_type: :json },
      verify_ssl: true
    )
  end

  it 'should serialize body to json when :content_type is any enhanced JSON content type' do
    post '/foo', { test: 'serialized' }, { content_type: 'application/vnd.airborne.2+json' }

    expect(RestClient::Request).to have_received(:execute).with(
      method: :post,
      url: 'http://www.example.com/foo',
      payload: { test: 'serialized' }.to_json,
      headers: { content_type: 'application/vnd.airborne.2+json' },
      verify_ssl: true
    )
  end

  it 'should not serialize body to json when :content_type does not match JSON' do
    post '/foo', { test: 'not serialized' }, { content_type: 'text/plain' }

    expect(RestClient::Request).to have_received(:execute).with(
      method: :post,
      url: 'http://www.example.com/foo',
      payload: { test: 'not serialized' },
      headers: { content_type: 'text/plain' },
      verify_ssl: true
    )
  end

  it 'should send payload with delete request' do
    payload = { example: 'this is the payload' }
    delete '/foo', payload

    expect(RestClient::Request).to have_received(:execute).with(
      method: :delete,
      url: 'http://www.example.com/foo',
      payload: payload.to_json,
      headers: { content_type: :json },
      verify_ssl: true
    )
  end

  context 'verify_ssl' do
    it 'should be true by default' do
      get '/foo'

      expect(RestClient::Request).to have_received(:execute).with(
        method: :get,
        url: 'http://www.example.com/foo',
        headers: { content_type: :json },
        verify_ssl: true
      )
    end

    it 'should be set by airborne config' do
      Airborne.configure { |config| config.verify_ssl = false }

      get '/foo'

      expect(RestClient::Request).to have_received(:execute).with(
        method: :get,
        url: 'http://www.example.com/foo',
        headers: { content_type: :json },
        verify_ssl: false
      )
    end

    it 'should be overriden with options[:verify_ssl]' do
      get '/foo', nil, false

      expect(RestClient::Request).to have_received(:execute).with(
        method: :get,
        url: 'http://www.example.com/foo',
        headers: { content_type: :json },
        verify_ssl: false
      )
    end

    it 'should override airborne config with options[:verify_ssl]' do
      Airborne.configure { |config| config.verify_ssl = false }

      get '/foo', nil, true

      expect(RestClient::Request).to have_received(:execute).with(
        method: :get,
        url: 'http://www.example.com/foo',
        headers: { content_type: :json },
        verify_ssl: true
      )
    end

    it 'should interpret airborne "config.verify_ssl = nil" as false' do
      Airborne.configure { |config| config.verify_ssl = nil }

      get '/foo'

      expect(RestClient::Request).to have_received(:execute).with(
        method: :get,
        url: 'http://www.example.com/foo',
        headers: { content_type: :json },
        verify_ssl: false
      )
    end

    context 'rspec metadata', verify_ssl: false do
      it 'should override the base airborne config with the rspec metadata' do
        get '/foo'

        expect(RestClient::Request).to have_received(:execute).with(
          method: :get,
          url: 'http://www.example.com/foo',
          headers: { content_type: :json },
          verify_ssl: false
        )
      end

      it 'should be overriden with options[:verify_ssl]' do
        get '/foo', nil, true

        expect(RestClient::Request).to have_received(:execute).with(
          method: :get,
          url: 'http://www.example.com/foo',
          headers: { content_type: :json },
          verify_ssl: true
        )
      end

      it 'should be overriden by supplied airborne config' do
        Airborne.configure { |config| config.verify_ssl = true }

        get '/foo'

        expect(RestClient::Request).to have_received(:execute).with(
          method: :get,
          url: 'http://www.example.com/foo',
          headers: { content_type: :json },
          verify_ssl: true
        )
      end
    end
  end
end
