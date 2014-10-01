require 'spec_helper'

describe 'expect_json with path' do

	it 'should allow simple path and verify only that path' do
		mock_get('simple_path_get')
		get '/simple_path_get'
		expect_json('address', {street: "Area 51", city: "Roswell", state: "NM"})
	end

	it 'should allow nested paths' do
		mock_get('simple_nested_path')
		get '/simple_nested_path'
		expect_json('address.coordinates', {lattitude: 33.3872, longitutde: 104.5281} )
	end

	it 'should index into array and test against specific element' do
		mock_get('array_with_index')
		get '/array_with_index'
		expect_json('cars.0', {make: "Tesla", model: "Model S"})
	end

	it 'should test against all elements in the array' do
		mock_get('array_with_index')
		get '/array_with_index'
		expect_json('cars.?', {make: "Tesla", model: "Model S"})
		expect_json('cars.?', {make: "Lamborghini", model: "Aventador"})
	end

	xit 'should test against properties in the array' do
		mock_get('array_with_index')
		get '/array_with_index'
		expect_json('cars.?.make', "Tesla")
	end

	it 'should work' do
    mock_get('array_with_nested')
    get '/array_with_nested'
    expect_json('cars.0.owners.0', {name: "Bart Simpson"})
  end

	it 'should allow strings (String) to be tested against a path' do
		mock_get('simple_nested_path')
		get '/simple_nested_path'
		expect_json('address.city', "Roswell" )
	end

	it 'should allow floats (Float) to be tested against a path' do
		mock_get('simple_nested_path')
		get '/simple_nested_path'
		expect_json('address.coordinates.lattitude', 33.3872 )
	end

	it 'should allow integers (Fixnum, Bignum) to be tested against a path' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json('age', 32 )
	end

end
