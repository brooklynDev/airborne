# frozen_string_literal: true

require 'spec_helper'

describe 'expect_json options' do
  describe 'match_expected', match_actual: false, match_expected: true do
    it 'requires all expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json(name: 'Alex', other: 'other') }.to raise_error(ExpectationNotMetError)
    end

    it 'does not require the actual properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect_json(name: 'Alex')
    end
  end

  describe 'match_actual', match_actual: true, match_expected: false do
    it 'requires all actual properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json(name: 'Alex') }.to raise_error(ExpectationError)
    end

    it 'does not require the expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect_json(name: 'Alex', age: 32, address: nil, other: 'other')
    end
  end

  describe 'match_both', match_actual: true, match_expected: true do
    it 'requires all actual properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json(name: 'Alex') }.to raise_error(ExpectationError)
    end

    it 'requires all expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json(name: 'Alex', other: 'other') }.to raise_error(ExpectationNotMetError)
    end

    it 'requires all expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect { expect_json(name: 'Alex', nested: {}) }.to raise_error(ExpectationNotMetError)
    end
  end

  describe 'match_none', match_actual: false, match_expected: false do
    it 'does not require the actual properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect_json(name: 'Alex')
    end

    it 'does not require the expected properties' do
      mock_get 'simple_get'
      get '/simple_get'
      expect_json(name: 'Alex', age: 32, address: nil, other: 'other', nested: {})
    end
  end
end
