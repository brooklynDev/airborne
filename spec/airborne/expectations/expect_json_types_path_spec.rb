# frozen_string_literal: true

require 'spec_helper'

describe 'expect_json_types wih path' do
  it 'allows simple path and verify only that path' do
    mock_get('simple_path_get')
    get '/simple_path_get'
    expect_json_types('address', street: :string, city: :string, state: :string)
  end

  it 'allows nested paths' do
    mock_get('simple_nested_path')
    get '/simple_nested_path'
    expect_json_types('address.coordinates', latitude: :float, longitude: :float)
  end

  it 'indexes into array and test against specific element' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect_json_types('cars.0', make: :string, model: :string)
  end

  it 'allows properties to be tested against a path' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect_json_types('cars.0.make', :string)
  end

  it 'tests against all elements in the array' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect_json_types('cars.*', make: :string, model: :string)
  end

  it 'ensures all elements of array are valid' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect { expect_json_types('cars.*', make: :string, model: :int) }.to raise_error(ExpectationNotMetError)
  end

  it 'deeps symbolize array responses' do
    mock_get('array_response')
    get '/array_response'
    expect_json_types('*', name: :string)
  end

  it 'checks all nested arrays for specified elements' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json_types('cars.*.owners.*', name: :string)
  end

  it 'ensures all nested arrays contain correct data' do
    mock_get('array_with_nested_bad_data')
    get '/array_with_nested_bad_data'
    expect { expect_json_types('cars.*.owners.*', name: :string) }.to raise_error(ExpectationNotMetError)
  end

  it 'raises ExpectationError when expectation expects an object instead of type' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect do
      expect_json_types('cars.0.make', make: :string)
    end.to raise_error(ExpectationError, "Expected String Tesla\nto be an object with property make")
  end
end
