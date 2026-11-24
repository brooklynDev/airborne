require_relative 'spec_helper'

RSpec.describe 'Airborne with Rails request specs', type: :request do
  it 'uses Rails requests and assertions against the Rails response (issue #167)' do
    expect(method(:get).owner.name).to start_with('ActionDispatch::')
    get '/api/users/1'

    expect_json('error', message: 'not found')
    expect_json_types('error', message: :string, id: :string)
    expect_json_keys('error', [:message, :id])
    expect_status(:not_found)
    expect_header_contains(:content_type, 'application/json')
    expect { expect_json('error', message: 'wrong') }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it 'reads the latest response on consecutive Rails requests' do
    get '/api/users/1'
    expect_json('error', id: '1')

    get '/api/users/2'
    expect_json('error', id: '2')
  end

  it 'accepts the Rails keyword arguments for JSON requests' do
    post '/api/users', params: { name: 'Alex' }, as: :json

    expect_status(:created)
    expect_json(name: 'Alex')
  end
end

RSpec.describe 'Airborne requests outside Rails request and controller specs' do
  it 'keeps the Airborne requester available when rspec-rails is loaded' do
    external_response = Struct.new(:code, :headers, :body).new(200, {}, '{"ok":true}')
    allow(RestClient::Request).to receive(:execute).and_return(external_response)

    expect(method(:get).owner).to eq(Airborne::RequestMethods)
    get 'https://example.test/ping'

    expect_status(200)
    expect_json(ok: true)
    expect(RestClient::Request).to have_received(:execute).with(hash_including(url: 'https://example.test/ping'))
  end
end

RSpec.describe AirborneRailsIntegration::UsersController, type: :controller do
  it 'uses Rails controller helpers and response accessors' do
    expect(method(:get).owner.name).to start_with('ActionController::')
    get :show, params: { id: '1' }

    expect_status(404)
    expect_json('error', message: 'not found', id: '1')
    expect_header_contains('Content-Type', 'application/json')
  end
end
