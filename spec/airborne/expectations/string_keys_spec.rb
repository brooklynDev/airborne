require 'spec_helper'

describe 'string keys in JSON assertions' do
  before do
    @response = Struct.new(:body).new('{"@id":"1234","nested":{"dc:title":"Unicorns"},"items":[{"name":"Alex"}]}')
  end

  it 'matches string and symbol keys in nested value assertions without changing the expectation' do
    expected = { '@id' => '1234', nested: { 'dc:title' => 'Unicorns' } }
    expect_json(expected)
    expect(expected[:nested].keys).to eq(['dc:title'])
    expect { expect_json('@id' => 'wrong') }.to raise_error(ExpectationNotMetError)
  end

  it 'matches string keys in type and optional assertions' do
    expect_json_types('@id' => :string, 'nested' => optional('dc:title' => :string))
    expect_json_types('items.*', 'name' => :string)
    expect { expect_json_types('@id' => :integer) }.to raise_error(ExpectationNotMetError)
  end

  it 'matches string keys in array expectations, key assertions, and size assertions' do
    expect_json('items', [{ 'name' => 'Alex' }])
    expect_json_keys(['@id', :nested])
    expect_json_keys('nested', ['dc:title'])
    expect_json_sizes('items' => 1)
  end

  context 'with exact matching', match_actual: true, match_expected: true do
    it 'does not mistake string keys for extra response keys' do
      expect_json('nested', 'dc:title' => 'Unicorns')
      expect { expect_json('nested', 'dc:title' => 'Unicorns', 'extra' => 'value') }.to raise_error(ExpectationNotMetError)
    end
  end

  context 'with intersection matching', match_actual: false, match_expected: false do
    it 'checks shared keys even when the expectation uses strings' do
      expect { expect_json('@id' => 'wrong') }.to raise_error(ExpectationNotMetError)
      expect { expect_json_types('@id' => :integer) }.to raise_error(ExpectationNotMetError)
    end
  end
end
