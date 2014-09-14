require 'spec_helper'

describe 'expect_json_types' do
	it 'should detect current type' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json_types({name: :string, age: :int})
	end

	it 'should fail when incorrect json types tested' do
		mock_get('simple_get')
		get '/simple_get'
		expect{expect_json_types({bad: :bool})}.to raise_error
	end

	it 'should not fail when optional property is not present' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json_types({name: :string, age: :int, optional: :bool_or_null })
	end
end
