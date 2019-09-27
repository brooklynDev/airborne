require 'date'

Gem::Specification.new do |s|
  s.name        = 'airborne'
  s.version     = '0.3.4'
  s.date        = Date.today.to_s
  s.summary = 'RSpec driven API testing framework'
  s.authors     = ['Alex Friedman', 'Seth Pollack']
  s.email       = ['a.friedman07@gmail.com', 'seth@sethpollack.net']
  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
  s.license     = 'MIT'
  s.add_runtime_dependency 'rspec', '~> 3.8'
  s.add_runtime_dependency 'rest-client', '< 3.0', '>= 2.0.2'
  s.add_runtime_dependency 'rack-test', '< 2.0', '>= 1.1.0'
  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'activesupport'
  s.add_development_dependency 'webmock', '~> 3'
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'github_changelog_generator', '~> 1.14'
end
