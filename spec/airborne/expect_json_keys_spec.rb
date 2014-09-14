require 'spec_helper'

describe 'expect_json_keys' do
	it 'should fail when json keys are missing' do
		mock_get('simple_json')
		get '/simple_json', {}
		expect{expect_json_keys([:foo, :bar, :baz, :bax])}.to raise_error
	end
end