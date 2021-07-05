require 'spec_helper'

describe 'expect header matches' do
  it 'should ensure partial header match exists' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect_header_matches(:content_type, /json/)
  end

  it 'should ensure header is present' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect { expect_header_matches(:foo, /json/) }.to raise_error
  end

  it 'should ensure partial header is present' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect { expect_header_matches(:content_type, /bar/) }.to raise_error
  end
end
