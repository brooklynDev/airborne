require 'spec_helper'

describe 'expect header' do
	it 'should find exact match for header content' do
		mock_get('simple_get', {'Content-Type' => 'application/json'})
		get '/simple_get'
		expect_header(:content_type, 'application/json')
	end

	it 'should ensure correct headers are present' do
		mock_get('simple_get', {'Content-Type' => 'application/json'})
		get '/simple_get'
		expect{expect_header(:foo, 'bar')}.to raise_error
	end	
end

describe 'expect header contains' do
	it 'should find partial match for header content' do
		mock_get('simple_get', {'Content-Type' => 'application/json'})
		get '/simple_get'
		expect_header_contains(:content_type, '')
	end
end