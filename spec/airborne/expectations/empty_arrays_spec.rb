require 'spec_helper'

describe 'empty arrays in wildcard assertions' do
  it 'preserves universal wildcard matching for empty arrays by default' do
    @response = Struct.new(:body).new('[]')
    expect_json_types('*', name: :string)
  end

  it 'requires an element for an any-element wildcard' do
    @response = Struct.new(:body).new('[]')
    expect { expect_json_types('?', name: :string) }.to raise_error(ExpectationNotMetError, /non-empty array/)
    expect { expect_json('?.name', 'Alex') }.to raise_error(ExpectationNotMetError, /non-empty array/)
  end

  context 'when nonempty wildcard results are required', allow_empty_arrays: false do
    it 'rejects empty root arrays for value, type, key, and size assertions' do
      @response = Struct.new(:body).new('[]')
      expect { expect_json('*', name: 'Alex') }.to raise_error(ExpectationNotMetError, /non-empty array/)
      expect { expect_json_types('*', name: :string) }.to raise_error(ExpectationNotMetError, /non-empty array/)
      expect { expect_json_keys('*', [:name]) }.to raise_error(ExpectationNotMetError, /non-empty array/)
      expect { expect_json_sizes('*', name: 4) }.to raise_error(ExpectationNotMetError, /non-empty array/)
    end

    it 'rejects empty arrays at intermediate and nested wildcards' do
      @response = Struct.new(:body).new('{"cars":[]}')
      expect { expect_json_types('cars.*.owners.*', name: :string) }.to raise_error(ExpectationNotMetError, /non-empty array/)
      @response = Struct.new(:body).new('{"cars":[{"owners":[]}]}')
      expect { expect_json_types('cars.*.owners.*', name: :string) }.to raise_error(ExpectationNotMetError, /non-empty array/)
    end

    it 'accepts matching nonempty arrays and explicit zero-size assertions' do
      @response = Struct.new(:body).new('{"items":[{"name":"Alex"}],"empty":[]}')
      expect_json_types('items.*', name: :string)
      expect_json_sizes(empty: 0)
    end
  end

  context 'with nonempty wildcard results required globally' do
    around do |example|
      previous_default = Airborne.configuration.allow_empty_arrays_default
      Airborne.configuration.allow_empty_arrays_default = false
      example.run
    ensure
      Airborne.configuration.allow_empty_arrays_default = previous_default
    end

    it 'rejects empty wildcard results by default' do
      @response = Struct.new(:body).new('[]')
      expect { expect_json_types('*', name: :string) }.to raise_error(ExpectationNotMetError, /non-empty array/)
    end

    it 'allows an example to opt back in to empty arrays', allow_empty_arrays: true do
      @response = Struct.new(:body).new('[]')
      expect_json_types('*', name: :string)
    end
  end
end
