require 'spec_helper'

describe 'expect_status' do
	it 'should verify correct status code' do
		mock_get('simple_get')
		get '/simple_get'
		expect_status(200)
	end

	it 'should fail when incorrect status code is returned' do
		mock_get('simple_get')
		get '/simple_get'
		expect{expect_status(123)}.to raise_error
	end
end