require 'json'
require 'sinatra'

class SampleApp < Sinatra::Application
  before do
      content_type 'application/json'
    end
  get '/' do
    {foo: "bar"}.to_json
  end
end

Airborne.configure do |config|
  config.rack_app = SampleApp
end

describe 'rack app' do
  it 'should allow requests against a sinatra app' do
    get '/'
    expect_json_types({foo: :string})
  end

  it 'should ensure correct values from sinatra app' do
    get '/'
    expect{expect_json_types({foo: :int})}.to raise_error
  end 
end