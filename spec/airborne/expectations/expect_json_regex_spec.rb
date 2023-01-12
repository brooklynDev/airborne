# frozen_string_literal: true

require 'spec_helper'

describe 'expect_json regex' do
  it 'tests against regex' do
    mock_get('simple_get')
    get '/simple_get'
    expect_json(name: regex('^A'))
  end

  it 'raises an error if regex does not match' do
    mock_get('simple_get')
    get '/simple_get'
    expect { expect_json(name: regex('^B')) }.to raise_error(ExpectationNotMetError)
  end

  it 'allows regex(Regexp) to be tested against a path' do
    mock_get('simple_nested_path')
    get '/simple_nested_path'
    expect_json('address.city', regex('^R'))
  end

  it 'allows testing regex against numbers directly' do
    mock_get('simple_nested_path')
    get '/simple_nested_path'
    expect_json('address.coordinates.latitude', regex('^3'))
  end

  it 'allows testing regex against numbers in the hash' do
    mock_get('simple_nested_path')
    get '/simple_nested_path'
    expect_json('address.coordinates', latitude: regex('^3'))
  end
end
