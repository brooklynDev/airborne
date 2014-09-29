require 'spec_helper'

describe 'expect_json_keys' do
  it 'should fail when json keys are missing' do
    mock_get('simple_json')
    get '/simple_json', {}
    expect{expect_json_keys([:foo, :bar, :baz, :bax])}.to raise_error
  end

  it 'should ensure correct json keys' do
    mock_get('simple_json')
    get '/simple_json', {}
    expect_json_keys([:foo, :bar, :baz])
  end 

  it 'should ensure correct partial json keys' do
    mock_get('simple_json')
    get '/simple_json', {}
    expect_json_keys([:foo, :bar])
  end

  it 'should ensure json keys with path' do
    mock_get('simple_nested_path')
    get '/simple_nested_path', {}
    expect_json_keys('address', [:street, :city])
  end 

  it 'should fail when keys are missing with path' do
    mock_get('simple_nested_path')
    get '/simple_nested_path', {}
    expect{expect_json_keys('address', [:bad])}.to raise_error
  end      
end