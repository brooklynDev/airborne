# frozen_string_literal: true

require 'spec_helper'

describe 'expect header contains' do
  it 'ensures partial header match exists' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect_header_contains(:content_type, 'json')
  end

  it 'ensures header is present' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect { expect_header_contains(:foo, 'bar') }.to raise_error(ExpectationNotMetError)
  end

  it 'ensures partial header is present' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect { expect_header_contains(:content_type, 'bar') }.to raise_error(ExpectationNotMetError)
  end
end
