require 'spec_helper'

describe 'expect header' do
  it 'should find exact match for header content' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect_header(:content_type, 'application/json')
  end

  it 'should find exact match for header content' do
    mock_get('simple_get', 'Content-Type' => 'json')
    get '/simple_get'
    expect { expect_header(:content_type, 'application/json') }.to raise_error(ExpectationNotMetError)
  end

  it 'should ensure correct headers are present' do
    mock_get('simple_get', 'Content-Type' => 'application/json')
    get '/simple_get'
    expect { expect_header(:foo, 'bar') }.to raise_error(ExpectationNotMetError)
  end

  describe 'with multi-value headers' do
    it 'should find exact match for header content' do
      mock_get('simple_get', 'Set-Cookie' => ['cookie-name=myvalue; Path=/', 'another=value;'])
      get '/simple_get'
      expect_header(:set_cookie, 'cookie-name=myvalue; Path=/')
    end

    it 'should find exact match for header content' do
      mock_get('simple_get', 'Set-Cookie' => ['cookie-name=myvalue; Path=/', 'another=value;'])
      get '/simple_get'
      expect { expect_header(:set_cookie, 'another=') }.to raise_error
    end
  end
end
