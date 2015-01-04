require 'spec_helper'

describe 'expect path' do 

	before :each do
		mock_get('array_with_index')
		get '/array_with_index'
	end

	it "should raise PathError when incorrect path containing .. is used" do 
		expect do
			expect_json('cars..make', "Tesla")
		end.to raise_error(Airborne::PathError, "Ivalid Path, contains '..'")
	end

	it "should raise PathError when trying to call property on an array" do
		expect do
			expect_json('cars.make', "Tesla")
		end.to raise_error(Airborne::PathError, "Expected Array\nto to be an object with property make")
	end
end