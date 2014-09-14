require 'spec_helper'

describe 'expect header' do
	it 'should find exact match for header content' do
		mock_get('simple_get', {'Content-Type' => 'text/json'})
		get '/simple_get'
		expect_header(:content_type, 'text/json')
	end
end

describe 'expect header contains' do
	it 'should find partial match for header content' do
		mock_get('simple_get', {'Content-Type' => 'text/json'})
		get '/simple_get'
		expect_header_contains(:content_type, '')
	end
end