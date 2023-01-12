# frozen_string_literal: true

require 'spec_helper'

describe 'expect_json_types options' do
  describe 'match_expected', match_actual: false, match_expected: true do
    it 'requires all expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json_types(name: :string, other: :string) }.to raise_error(ExpectationNotMetError)
    end

    it 'does not require the actual properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect_json_types(name: :string)
    end
  end

  describe 'match_actual', match_actual: true, match_expected: false do
    it 'requires all actual properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json_types(name: :string) }.to raise_error(ExpectationError)
    end

    it 'does not require the expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect_json_types(name: :string, age: :int, address: :null, other: :string)
    end
  end

  describe 'match_both', match_actual: true, match_expected: true do
    it 'requires all actual properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json_types(name: :string) }.to raise_error(ExpectationError)
    end

    it 'requires all expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json_types(name: :string, other: :string) }.to raise_error(ExpectationNotMetError)
    end
  end

  describe 'match_none', match_actual: false, match_expected: false do
    it 'does not require the actual properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect_json_types(name: :string)
    end

    it 'does not require the expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect_json_types(name: :string, age: :int, address: :null, other: :string)
    end
  end
end
