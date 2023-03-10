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
  config.rack_browser = Rack::Test::Session.new(Rack::MockSession.new(SampleApp))
end

describe 'rack app via browser' do
  it 'should allow requests against a sinatra app' do
    get '/'
    expect_json_types(foo: :string)
  end
end
