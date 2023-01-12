# frozen_string_literal: true

require 'spec_helper'

describe 'head' do
  it 'allows testing on head requests' do
    mock_head('simple_head', 'foo' => 'foo')
    head '/simple_head', {}
    expect_status 200
    expect_header('foo', 'foo')
  end
end
