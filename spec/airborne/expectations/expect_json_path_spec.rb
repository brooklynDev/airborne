# frozen_string_literal: true

require 'spec_helper'

describe 'expect_json with path' do
  it 'allows simple path and verify only that path' do
    mock_get('simple_path_get')
    get '/simple_path_get'
    expect_json('address', street: 'Area 51', city: 'Roswell', state: 'NM')
  end

  it 'allows nested paths' do
    mock_get('simple_nested_path')
    get '/simple_nested_path'
    expect_json('address.coordinates', latitude: 33.3872, longitude: 104.5281)
  end

  it 'indexes into array and test against specific element' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect_json('cars.0', make: 'Tesla', model: 'Model S')
  end

  it 'tests against all elements in the array' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect_json('cars.?', make: 'Tesla', model: 'Model S')
    expect_json('cars.?', make: 'Lamborghini', model: 'Aventador')
  end

  it 'tests against properties in the array' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect_json('cars.?.make', 'Tesla')
  end

  it 'ensures at least one match' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect { expect_json('cars.?.make', 'Teslas') }.to raise_error(ExpectationNotMetError)
  end

  it 'checks for at least one match' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json('cars.?.owners.?', name: 'Bart Simpson')
  end

  it 'ensures at least one match' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect { expect_json('cars.?.owners.?', name: 'Bart Simpsons') }.to raise_error(ExpectationNotMetError)
  end

  it 'checks for one match that matches all' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json('cars.?.owners.*', name: 'Bart Simpson')
  end

  it 'checks for one match that matches all with lambda' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json('cars.?.owners.*', name: ->(name) { expect(name).to eq('Bart Simpson') })
  end

  it 'ensures one match that matches all with lambda' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect do
      expect_json('cars.?.owners.*', name: ->(name) { expect(name).to eq('Bart Simpsons') })
    end.to raise_error(ExpectationNotMetError)
  end

  it 'ensures one match that matches all' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect { expect_json('cars.?.owners.*', name: 'Bart Simpsons') }.to raise_error(ExpectationNotMetError)
  end

  it 'allows indexing' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json('cars.0.owners.0', name: 'Bart Simpson')
  end

  it 'allows strings (String) to be tested against a path' do
    mock_get('simple_nested_path')
    get '/simple_nested_path'
    expect_json('address.city', 'Roswell')
  end

  it 'allows floats (Float) to be tested against a path' do
    mock_get('simple_nested_path')
    get '/simple_nested_path'
    expect_json('address.coordinates.latitude', 33.3872)
  end

  it 'allows integers (Fixnum, Bignum) to be tested against a path' do
    mock_get('simple_get')
    get '/simple_get'
    expect_json('age', 32)
  end

  it 'raises ExpectationError when expectation expects an object instead of value' do
    mock_get('array_with_index')
    get '/array_with_index'
    expect do
      expect_json('cars.0.make', make: 'Tesla')
    end.to raise_error(ExpectationError, "Expected String Tesla\nto be an object with property make")
  end
end
