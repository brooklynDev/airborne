require 'spec_helper'
require 'rest_client'

describe 'expect_json_types' do
	it 'should detect current type' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json_types({name: :string, age: :int})
	end
end

describe 'expect header' do
	it 'should find exact match for header content' do
		mock_get('simple_get')
		get '/simple_get'
		expect_header(:content_type, 'text/json')
	end
end

describe 'expect header contains' do
	it 'should find partial match for header content' do
		mock_get('simple_get')
		get '/simple_get'
		expect_header_contains(:content_type, '')
	end
end