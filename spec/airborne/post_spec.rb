require 'spec_helper'

describe 'post' do
	it 'should allow testing on post requests' do
		mock_post('simple_post')
		post '/simple_post', {}
		expect_json_types({status: :string, someNumber: :int})
	end
end