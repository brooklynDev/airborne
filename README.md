# Airborne

[![airborne travis](http://img.shields.io/travis/brooklynDev/airborne.svg?branch=master&style=flat-square)](https://travis-ci.org/brooklynDev/airborne)
[![airborne coveralls](http://img.shields.io/coveralls/brooklynDev/airborne/master.svg?style=flat-square)](https://coveralls.io/r/brooklynDev/airborne?branch=master)
[![airborne gem version](http://img.shields.io/gem/v/airborne.svg?style=flat-square)](http://rubygems.org/gems/airborne)
[![airbore gem downloads](http://img.shields.io/gem/dt/airborne.svg?style=flat-square)](http://rubygems.org/gems/airborne)
[![airborne gem stable downloads](http://img.shields.io/gem/dv/airborne/stable.svg?style=flat-square)](http://rubygems.org/gems/airborne)

RSpec driven API testing framework inspired by [frisby.js](https://github.com/vlucas/frisby)

## Installation

Install Airborne:

    gem install airborne
    
Or add it to your Gemfile:

    gem 'airborne'

##Creating Tests

```ruby
require 'airborne'

describe 'sample spec' do
  it 'should validate types' do
    get 'http://example.com/api/v1/simple_get' #json api that returns { "name" : "John Doe" } 
    expect_json_types({name: :string})
  end

  it 'should validate values' do 
    get 'http://example.com/api/v1/simple_get' #json api that returns { "name" : "John Doe" } 
    expect_json({:name => "John Doe"})
  end
end
```

When calling expect_json_types, these are the valid types that can be tested against:

* `:int` or `:integer`
* `:float`
* `:bool` or `:boolean`
* `:string`
* `:object`
* `:array`
* `:array_of_integers` or `:array_of_ints`
* `:array_of_floats`
* `:array_of_strings`
* `:array_of_booleans` or `:array_of_bools`
* `:array_of_objects`
* `:array_of_arrays`

If the properties are optional and may not appear in the response, you can append `_or_null` to the types above.
    
```ruby
describe 'sample spec' do
  it 'should validate types' do
    get 'http://example.com/api/v1/simple_get' #json api that returns { "name" : "John Doe" } or { "name" : "John Doe", "age" : 45 }
    expect_json_types({name: :string, age: :int_or_null})
  end
end
```

Additionally, if an entire object could be null, but you'd still want to test the types if it does exist, you can wrap the expectations in a call to `optional`:

```ruby
it 'should allow optional nested hash' do
  get '/simple_path_get' #may or may not return coordinates
  expect_json_types("address.coordinates", optional({latitude: :float, longitude: :float}))
end
```

Additionally, when calling `expect_json`, you can provide a regex pattern in a call to `regex`:

```ruby
describe 'sample spec' do
  it 'should validate types' do
    get 'http://example.com/api/v1/simple_get' #json api that returns { "name" : "John Doe" }
    expect_json({name: regex("^John")})
  end
end
```

When calling `expect_json` or `expect_json_types`, you can optionally provide a block and run your own `rspec` expectations:

```ruby
describe 'sample spec' do
  it 'should validate types' do
    get 'http://example.com/api/v1/simple_get' #json api that returns { "name" : "John Doe" }
    expect_json({name: -> (name){expect(name.length).to eq(8)}})
  end
end
```

##Making requests

Airborne uses `rest_client` to make the HTTP request, and supports all HTTP verbs. When creating a test, you can call any of the following methods: `get`, `post`, `put`, `patch`, `delete`. This will then give you access the following properties:

* `response` - The HTTP response returned from the request
* `headers` - A symbolized hash of the response headers returned by the request
* `body` - The raw HTTP body returned from the request
* `json_body` - A symbolized hash representation of the JSON returned by the request

For example:

```ruby
it 'should validate types' do
  get 'http://example.com/api/v1/simple_get' #json api that returns { "name" : "John Doe" } 
  name = json_body[:name] #name will equal "John Doe"
  body_as_string = body
end
```

When calling any of the methods above, you can pass request headers to be used. 

```ruby
get 'http://example.com/api/v1/my_api', {'x-auth-token' => 'my_token'}
```

For requests that require a body (`post`, `put`, `patch`) you can pass the body as a hash as well:
    
```ruby
post 'http://example.com/api/v1/my_api', {:name => 'John Doe'}, {'x-auth-token' => 'my_token'}
```

##Testing Rack Applications

If you have an existing Rack application like `sinatra` or `grape` you can run Airborne against your application and test without actually having a server running. To do that, just specify your rack application in your Airborne configuration:

```ruby
Airborne.configure do |config|
    config.rack_app = MySinatraApp
end
```

Under the covers, Airborne uses [rack-test](https://github.com/brynary/rack-test) to make the requests. (Rails applications are still not working correctly, support for Rails will come soon!)
  
##API

* `expect_json_types` - Tests the types of the JSON property values returned
* `expect_json` - Tests the values of the JSON property values returned
* `expect_json_keys` - Tests the existence of the specified keys in the JSON object
* `expect_status` - Tests the HTTP status code returned
* `expect_header` - Tests for a specified header in the response
* `expect_header_contains` - Partial match test on a specified header

##Path Matching

When calling `expect_json_types`, `expect_json` or `expect_json_keys` you can optionally specify a path as a first parameter. 

For example, if our API returns the following JSON:

```json
{
  "name": "Alex",
  "address": {
    "street": "Area 51",
    "city": "Roswell",
    "state": "NM",
    "coordinates": {
      "latitude": 33.3872,
      "longitude": 104.5281
    }
  }
}
```
    
This test would only test the address object:
    
```ruby
describe 'path spec' do
  it 'should allow simple path and verify only that path' do
    get 'http://example.com/api/v1/simple_path_get'
    expect_json_types('address', {street: :string, city: :string, state: :string, coordinates: :object })
    #or this
    expect_json_types('address', {street: :string, city: :string, state: :string, coordinates: { latitude: :float, longitude: :float } })
  end
end
```
Or, to test the existence of specific keys:

```ruby
it 'should allow nested paths' do
  get 'http://example.com/api/v1/simple_path_get'
  expect_json_keys('address', [:street, :city, :state, :coordinates])    
end
```

Alternativley, if we only want to test `coordinates` we can dot into just the `coordinates`:

```ruby
it 'should allow nested paths' do
  get 'http://example.com/api/v1/simple_path_get'
  expect_json('address.coordinates', {latitude: 33.3872, longitude: 104.5281} )     
end
```

When dealing with `arrays`, we can optionally test all (`*`) or a single (`?` - any, `0` - index) element of the array:

Given the following JSON:

```json
{
  "cars": [
    {
      "make": "Tesla",
      "model": "Model S"
    },
    {
      "make": "Lamborghini",
      "model": "Aventador"
    }
  ]
}
```

We can test against just the first car like this:

```ruby
it 'should index into array and test against specific element' do 
  get '/array_api'
  expect_json('cars.0', {make: "Tesla", model: "Model S"})
end
```

To test the types of all elements in the array:

```ruby
it 'should test all elements of the array' do 
  get 'http://example.com/api/v1/array_api'
  expect_json('cars.?', {make: "Tesla", model: "Model S"}) # tests that one car in array matches the tesla
  expect_json_types('cars.*', {make: :string, model: :string}) # tests all cars in array for make and model of type string
end
```
    
`*` and `?` work for nested arrays as well. Given the following JSON:

```json
{
  "cars": [
    {
      "make": "Tesla",
      "model": "Model S",
      "owners": [
        {
          "name": "Bart Simpson"
        }
      ]
    },
    {
      "make": "Lamborghini",
      "model": "Aventador",
      "owners": [
        {
          "name": "Peter Griffin"
        }
      ]
    }
  ]
}
```

===

```ruby
it 'should check all nested arrays for specified elements' do
  get 'http://example.com/api/v1/array_with_nested'
  expect_json_types('cars.*.owners.*', {name: :string})
end
```

##Configuration

When setting up Airborne, you can call `configure` just like you would with `rspec`:

```ruby
#config is the RSpec configuration and can be used just like it
Airborne.configure.do |config|
  config.include MyModule
end
```

Additionally, you can specify a `base_url` and default `headers` to be used on every request (unless overridden in the actual request):

```ruby
Airborne.configure.do |config|
  config.base_url = 'http://example.com/api/v1'
  config.headers = {'x-auth-token' => 'my_token'}
end

describe 'spec' do
  it 'now we no longer need the full url' do
    get '/simple_get'
    expect_json_types({name: :string})
  end
end
```

### Run it from the CLI

    $ cd your/project
    $ rspec spec
    
## License 

The MIT License

Copyright (c) 2014 [brooklyndev](https://github.com/brooklynDev), [sethpollack](https://github.com/sethpollack)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
