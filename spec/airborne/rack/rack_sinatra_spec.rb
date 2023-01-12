# frozen_string_literal: true

require 'json'
require 'sinatra'

class SampleApp < Sinatra::Application
  before do
    content_type 'application/json'
  end

  get '/' do
    { foo: 'bar' }.to_json
  end
end

Airborne.configure do |config|
  config.rack_app = SampleApp
end

describe 'rack app' do
  it 'allows requests against a sinatra app' do
    get '/'
    expect_json_types(foo: :string)
  end

  it 'ensures correct values from sinatra app' do
    get '/'
    expect { expect_json_types(foo: :int) }.to raise_error(ExpectationNotMetError)
  end

  it 'sets json_body even when not using the airborne http requests' do
    response_class = Struct.new(:body, :headers)
    @response = response_class.new({ foo: 'bar' }.to_json)
    expect(json_body).to eq(foo: 'bar')
  end

  it 'works with consecutive requests' do
    response_class = Struct.new(:body, :headers)
    @response = response_class.new({ foo: 'bar' }.to_json)
    expect(json_body).to eq(foo: 'bar')

    @response = response_class.new({ foo: 'boo' }.to_json)
    expect(json_body).to eq(foo: 'boo')
  end
end
