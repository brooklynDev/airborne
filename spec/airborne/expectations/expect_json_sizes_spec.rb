# frozen_string_literal: true

require 'spec_helper'

describe 'expect_json_sizes' do
  it 'detects sizes' do
    mock_get('array_of_values')
    get '/array_of_values'
    expect_json_sizes(grades: 4, bad: 3, emptyArray: 0)
  end

  it 'allows full object graph' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json_sizes(cars: { 0 => { owners: 1 }, 1 => { owners: 1 } })
  end

  it 'allows properties to be tested against a path' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json_sizes('cars.0.owners', 1)
  end

  it 'tests against all elements in the array when path contains * AND expectation is an Integer' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json_sizes('cars.*.owners', 1)
  end

  it 'tests against all elements in the array when path contains * AND expectation is a Hash' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json_sizes('cars.*', owners: 1)
  end
end
