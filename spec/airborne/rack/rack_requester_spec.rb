require 'spec_helper'
require 'rack/lint'

describe 'Rack requests' do
  include Airborne::RackTestRequester

  around do |example|
    previous_app = Airborne.configuration.rack_app
    previous_headers = Airborne.configuration.headers
    Airborne.configuration.headers = {}
    example.run
  ensure
    Airborne.configuration.rack_app = previous_app
    Airborne.configuration.headers = previous_headers
  end

  def rack_app(&block)
    Airborne.configuration.rack_app = Rack::Lint.new(block)
  end

  it 'supports JSON and symbolic status assertions' do
    rack_app { |env| [201, { 'content-type' => 'application/json' }, ['{"id":42}']] }

    get '/items'

    expect_status(:created)
    expect_json(id: 42)
    expect_json_types(id: :integer)
  end

  it 'looks up response headers using HTTP names or underscored symbols' do
    rack_app { |env| [200, { 'content-type' => 'application/json' }, ['{}']] }

    get '/'

    expect(headers[:content_type]).to eq('application/json')
    expect(headers['content-type']).to eq('application/json')
    expect(headers['Content-Type']).to eq('application/json')
    expect_header(:content_type, 'Application/JSON')
    expect_header('Content-Type', 'application/json')
    expect_header_contains('CONTENT-TYPE', 'JSON')
  end

  it 'preserves query parameters on GET requests' do
    rack_app do |env|
      [200, { 'content-type' => 'application/json' }, [Rack::Request.new(env).GET.to_json]]
    end

    get '/items?name=hello%20world'

    expect_json(name: 'hello world')
  end

  it 'continues to submit hash bodies as form parameters' do
    rack_app do |env|
      [200, { 'content-type' => 'application/json' }, [Rack::Request.new(env).POST.to_json]]
    end

    post '/items', { name: 'hello world' }

    expect_json(name: 'hello world')
  end

  [:post, :put, :patch, :delete].each do |verb|
    it "sends a raw JSON body and request headers with #{verb}" do
      rack_app do |env|
        payload = {
          method: env['REQUEST_METHOD'],
          input: env['rack.input'].read,
          content_type: env['CONTENT_TYPE'],
          token: env['HTTP_X_TOKEN'],
          default_header: env['HTTP_X_DEFAULT']
        }
        [200, { 'content-type' => 'application/json' }, [payload.to_json]]
      end
      Airborne.configuration.headers = { 'X-Token' => 'default', 'X-Default' => 'preserved' }

      send(verb, '/items', '{"name":"test"}', 'Content-Type' => 'application/json', 'X-Token' => 'override')

      expect_json(method: verb.to_s.upcase, input: '{"name":"test"}',
                  content_type: 'application/json', token: 'override', default_header: 'preserved')
    end
  end

  [:head, :options].each do |verb|
    it "supports #{verb} requests" do
      rack_app { |env| [204, { 'x-method' => env['REQUEST_METHOD'] }, []] }

      send(verb, '/')

      expect_status(204)
      expect_header('X-Method', verb.to_s.upcase)
      expect(body).to eq('')
    end
  end

  if Gem::Version.new(Rack.release) >= Gem::Version.new('3.0')
    it 'preserves repeated response headers and matches individual values' do
      rack_app do |env|
        [200, { 'set-cookie' => ['first=one; Path=/', 'second=two; Path=/'] }, ['{}']]
      end

      get '/'

      expect(headers[:set_cookie]).to eq(['first=one; Path=/', 'second=two; Path=/'])
      expect_header('Set-Cookie', 'SECOND=TWO; PATH=/')
      expect_header_contains(:set_cookie, 'FIRST=ONE')
      expect { expect_header(:set_cookie, 'missing') }.to raise_error(ExpectationNotMetError)
      expect { expect_header_contains(:set_cookie, 'missing') }.to raise_error(ExpectationNotMetError)
      expect { expect_header(:set_cookie, 'first=one') }.to raise_error(ExpectationNotMetError)
    end
  end
end
