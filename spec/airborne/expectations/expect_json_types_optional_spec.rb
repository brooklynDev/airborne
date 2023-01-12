# frozen_string_literal: true

require 'spec_helper'

describe 'expect_json_types optional' do
  it 'tests optional nested hash when exists' do
    mock_get('simple_nested_path')
    get '/simple_nested_path'
    expect_json_types('address.coordinates', optional(latitude: :float, longitude: :float))
  end

  it 'allows optional nested hash' do
    mock_get('simple_path_get')
    get '/simple_path_get'
    expect_json_types('address.coordinates', optional(latitude: :float, longitude: :float))
  end
end
