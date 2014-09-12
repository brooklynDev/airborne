require 'spec_helper'
require 'rest_client'

describe 'expect_json_types' do
	it 'should detect current type' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json_types({name: :string, age: :int})
	end
end