require 'spec_helper'
require 'json'
require 'sinatra'

class SampleApp < Sinatra::Application
  set :environment, :test

  before do
    content_type 'application/json'
  end

  get '/' do
    { foo: 'bar' }.to_json
  end
end

describe 'rack app' do
  include Airborne::RackTestRequester

  around do |example|
    previous_app = Airborne.configuration.rack_app
    Airborne.configuration.rack_app = SampleApp
    example.run
  ensure
    Airborne.configuration.rack_app = previous_app
  end

  it 'should allow requests against a sinatra app' do
    get '/'
    expect_json_types(foo: :string)
  end

  it 'should ensure correct values from sinatra app' do
    get '/'
    expect { expect_json_types(foo: :int) }.to raise_error(ExpectationNotMetError)
  end

  it 'Should set json_body even when not using the airborne http requests' do
    @response = Struct.new(:body, :headers).new({ foo: 'bar' }.to_json)
    expect(json_body).to eq(foo: 'bar')
  end

  it 'Should work with consecutive requests' do
    response_class = Struct.new(:body, :headers)
    @response = response_class.new({ foo: 'bar' }.to_json)
    expect(json_body).to eq(foo: 'bar')

    @response = response_class.new({ foo: 'boo' }.to_json)
    expect(json_body).to eq(foo: 'boo')
  end
end
