# frozen_string_literal: true

require 'spec_helper'

describe 'expect path' do
  describe 'errors' do
    before do
      mock_get('array_with_index')
      get '/array_with_index'
    end

    it 'raises PathError when incorrect path containing .. is used' do
      expect do
        expect_json('cars..make', 'Tesla')
      end.to raise_error(PathError, "Invalid Path, contains '..'")
    end

    it 'raises PathError when trying to call property on an array' do
      expect do
        expect_json('cars.make', 'Tesla')
      end.to raise_error(PathError, "Expected Array\nto be an object with property make")
    end
  end

  it 'works with numberic properties' do
    mock_get('numeric_property')
    get '/numeric_property'
    expect_json('cars.0.make', 'Tesla')
  end

  it 'works with numberic properties' do
    mock_get('numeric_property')
    get '/numeric_property'
    expect_json_keys('cars.0', [:make, :model])
  end
end
