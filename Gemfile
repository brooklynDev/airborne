source 'https://rubygems.org'

gemspec

gem 'rack', ENV['RACK_VERSION'] if ENV['RACK_VERSION']

gem 'coveralls', require: false
gem 'faraday-retry', require: false

group :test do
  gem 'webmock'
  gem 'sinatra', ENV.fetch('SINATRA_VERSION', '>= 0')
end
