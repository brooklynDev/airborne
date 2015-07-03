require 'spec_helper'

describe 'expect_json_types' do
  it 'should detect current type' do
    mock_get('simple_get')
    get '/simple_get'
    expect_json_types(name: :string, age: :int)
  end

  it 'should fail when incorrect json types tested' do
    mock_get('simple_get')
    get '/simple_get'
    expect { expect_json_types(bad: :bool) }.to raise_error
  end

  it 'should not fail when optional property is not present' do
    mock_get('simple_get')
    get '/simple_get'
    expect_json_types(name: :string, age: :int, optional: :bool_or_null)
  end

  it 'should allow full object graph' do
    mock_get('simple_path_get')
    get '/simple_path_get'
    expect_json_types(name: :string, address: { street: :string, city: :string, state: :string })
  end

  it 'should check all types in a simple array' do
    mock_get('array_of_values')
    get '/array_of_values'
    expect_json_types(grades: :array_of_ints)
  end

  it 'should ensure all valid types in a simple array' do
    mock_get('array_of_values')
    get '/array_of_values'
    expect { expect_json_types(bad: :array_of_ints) }.to raise_error
  end

  it 'should allow empty array' do
    mock_get('array_of_values')
    get '/array_of_values'
    expect_json_types(emptyArray: :array_of_ints)
  end

  it 'should be able to test for a nil type' do
    mock_get('simple_get')
    get '/simple_get'
    expect_json_types(name: :string, age: :int, address: :null)
  end

  it 'Should throw bad type error' do
    mock_get('simple_get')
    get '/simple_get'
    expect { expect_json_types(name: :foo) }.to raise_error(Airborne::ExpectationError, "Expected type foo\nis an invalid type")
  end
end
