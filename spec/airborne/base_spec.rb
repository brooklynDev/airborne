require 'spec_helper'

describe 'base spec' do
  it 'when request is made response should be set' do
    mock_get('simple_get')
    get '/simple_get'
    expect(response).to_not be(nil)
  end

  it 'when request is made headers should be set' do
    mock_get('simple_get')
    get '/simple_get'
    expect(headers).to_not be(nil)
  end

  it 'should throw an InvalidJsonError when accessing json_body on invalid json' do
    mock_get('invalid_json')
    get '/invalid_json'
    expect(body).to eq('invalid1234')
    expect { json_body }.to raise_error(InvalidJsonError)
  end

  it 'when request is made headers should be hash with indifferent access' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect(headers).to be_kind_of(Hash)
    expect(headers[:content_type]).to eq('application/json')
    expect(headers['content_type']).to eq('application/json')
    expect(headers['Content-Type']).to eq('application/json')
    expect(headers['content-type']).to eq('application/json')
  end

  it 'when request is made body should be set' do
    mock_get('simple_get')
    get '/simple_get'
    expect(body).to_not be(nil)
  end

  it 'normalizes mixed-case Rack response headers without changing the response' do
    original_headers = { 'Content-Type' => 'application/json', 'X-Request-ID' => 'request-42' }.freeze
    @response = Struct.new(:headers).new(original_headers)

    expect(headers[:content_type]).to eq('application/json')
    expect(headers['X-Request-ID']).to eq('request-42')
    expect(headers.fetch(:x_request_id)).to eq('request-42')
    expect(headers.key?('X-REQUEST-ID')).to eq(true)
    expect(response.headers).to eq('Content-Type' => 'application/json', 'X-Request-ID' => 'request-42')
  end

  it 'normalizes headers already wrapped in a hash with indifferent access' do
    @response = Struct.new(:headers).new(HashWithIndifferentAccess.new('Content-Type' => 'application/json'))

    expect(headers[:content_type]).to eq('application/json')
    expect_header('CONTENT-TYPE', 'application/json')
  end

  it 'when request is made json body should be symbolized hash' do
    mock_get('simple_get')
    get '/simple_get'
    expect(json_body).to be_kind_of(Hash)
    expect(json_body.first[0]).to be_kind_of(Symbol)
  end

  it 'should handle a 500 error on get' do
    mock_get('simple_get', {}, [500, 'Internal Server Error'])
    get '/simple_get'
    expect(json_body).to_not be(nil)
  end

  it 'should handle a 500 error on post' do
    mock_post('simple_post', {}, [500, 'Internal Server Error'])
    post '/simple_post', {}
    expect(json_body).to_not be(nil)
  end
end
