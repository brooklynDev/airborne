require 'spec_helper'

describe 'expect_json' do
	it 'should ensure correct json values' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json({name: "Alex", age: 32 })
	end

	it 'should fail when incorrect json is tested' do
		mock_get('simple_get')
		get '/simple_get'
		expect{expect_json({bad: "data"})}.to raise_error		
	end
	
	it 'should allow simple path and verify only that path' do
		mock_get('simple_path_get')
		get '/simple_path_get'
		expect_json('address', {street: "Area 51", city: "Roswell", state: "NM"})
	end
	
	it 'should allow full object graph' do
		mock_get('simple_path_get')
		get '/simple_path_get'
		expect_json({name: "Alex", address: {street: "Area 51", city: "Roswell", state: "NM"}})
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

	it 'should invoke proc passed in' do
		mock_get('simple_get')
		get '/simple_get'
		expect_json({name: -> (name){expect(name.length).to eq(4)}})
	end

end