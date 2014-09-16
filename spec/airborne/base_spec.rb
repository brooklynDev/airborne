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

	it 'when request is made headers should be symbolized hash' do
		mock_get('simple_get', {'Content-Type' => 'application/json'})
		get '/simple_get'
		expect(headers).to be_kind_of(Hash)
		expect(headers.first[0]).to be_kind_of(Symbol)		
	end	

	it 'when request is made body should be set' do
		mock_get('simple_get')
		get '/simple_get'
		expect(body).to_not be(nil)		
	end

	it 'when request is made json body should be symbolized hash' do
		mock_get('simple_get')
		get '/simple_get'
		expect(json_body).to be_kind_of(Hash)
		expect(json_body.first[0]).to be_kind_of(Symbol)		
	end
end