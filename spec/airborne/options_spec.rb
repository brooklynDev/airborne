# frozen_string_literal: true

require 'spec_helper'

describe 'head' do
  it 'allows testing on options requests' do
    mock_options('simple_options', 'foo' => 'foo')
    options '/simple_options', {}
    expect_status 200
    expect_header('foo', 'foo')
  end
end
