require 'spec_helper'

describe 'head' do
  it 'should allow testing on head requests' do
    mock_head('simple_head')
    head '/simple_head', {}
    expect_status(200)
    expect(json_body).to be(nil)
  end
end
