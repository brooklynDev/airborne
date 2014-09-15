require 'spec_helper'

describe 'expect_json_types' do
	it 'should detect current type' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json_types({name: :string, age: :int})
	end

	it 'should fail when incorrect json types tested' do
		mock_get('simple_get')
		get '/simple_get'
		expect{expect_json_types({bad: :bool})}.to raise_error
	end

	it 'should not fail when optional property is not present' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json_types({name: :string, age: :int, optional: :bool_or_null })
	end

	it 'should allow simple path and verify only that path' do
		mock_get('simple_path_get')
		get '/simple_path_get'
		expect_json_types('address', {street: :string, city: :string, state: :string})
	end

	it 'should allow nested paths' do
		mock_get('simple_nested_path')
		get '/simple_nested_path'
		expect_json_types('address.coordinates', {lattitude: :float, longitutde: :float} )		
	end

	it 'should index into array and test against specific element' do 
		mock_get('array_with_index')
		get '/array_with_index'
		expect_json_types('cars.0', {make: :string, model: :string})
	end
end
