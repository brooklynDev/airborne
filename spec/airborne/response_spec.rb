require 'spec_helper'

describe 'response' do
  let(:headers) { {} }
  let(:status) { 200 }

  before { Airborne.configuration.rest_client_options = { max_redirects: 0 } }
  after { Airborne.configuration.rest_client_options = {} }

  before do
    mock_get('simple_get', headers, status)
    get '/simple_get'
  end

  context 'with 200 status' do
    let(:status) { 200 }

    it { expect(response.status).to eq 200 }
    it { expect(response).to be_successful }
    it { expect(response).to be_success }
    it { expect(response).to be_ok }
  end

  context 'with 404 status' do
    let(:status) { 404 }

    it { expect(response.status).to eq 404 }
    it { expect(response).to_not be_success }
    it { expect(response).to_not be_ok }
    it { expect(response).to be_client_error }
    it { expect(response).to be_not_found }
    it { expect(response).to be_missing }
  end

  context 'with 302 status' do
    let(:status) { 302 }
    let(:headers) { { 'Location' => '/' } }

    it { expect(response.status).to eq 302 }
    it { expect(response).to be_redirection }
    it { expect(response).to be_redirect }
  end

  context 'with 500 status' do
    let(:status) { 500 }

    it { expect(response.status).to eq 500 }
    it { expect(response).to_not be_success }
    it { expect(response).to_not be_ok }
    it { expect(response).to be_server_error }
    it { expect(response).to be_error }
  end
end
