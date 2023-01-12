# frozen_string_literal: true

require 'spec_helper'

describe 'expect_json_keys' do
  it 'fails when json keys are missing' do
    mock_get('simple_json')
    get '/simple_json', {}
    expect { expect_json_keys([:foo, :bar, :baz, :bax]) }.to raise_error(ExpectationNotMetError)
  end

  it 'ensures correct json keys' do
    mock_get('simple_json')
    get '/simple_json', {}
    expect_json_keys([:foo, :bar, :baz])
  end

  it 'ensures correct partial json keys' do
    mock_get('simple_json')
    get '/simple_json', {}
    expect_json_keys([:foo, :bar])
  end
end
