# Change Log

## [Unreleased](https://github.com/brooklynDev/airborne/tree/HEAD)

[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.19...HEAD)

**Closed issues:**

- In case of multiple requests, expect\_json keeps checking with response of first request. [\#71](https://github.com/brooklynDev/airborne/issues/71)

## [v0.1.19](https://github.com/brooklynDev/airborne/tree/v0.1.19) (2015-08-07)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.18...v0.1.19)

## [v0.1.18](https://github.com/brooklynDev/airborne/tree/v0.1.18) (2015-08-07)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.17...v0.1.18)

## [v0.1.17](https://github.com/brooklynDev/airborne/tree/v0.1.17) (2015-08-07)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.16...v0.1.17)

**Closed issues:**

- Compatibility with rspec-rails [\#70](https://github.com/brooklynDev/airborne/issues/70)
- Can `subject` be called when one of the API methods is called?  [\#47](https://github.com/brooklynDev/airborne/issues/47)

**Merged pull requests:**

- Allow expectations on consecutive requests to work [\#69](https://github.com/brooklynDev/airborne/pull/69) ([balvig](https://github.com/balvig))

## [v0.1.16](https://github.com/brooklynDev/airborne/tree/v0.1.16) (2015-07-06)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.15...v0.1.16)

**Implemented enhancements:**

- Add :null to the json\_types mapper [\#61](https://github.com/brooklynDev/airborne/issues/61)
- better error messages when passing bad options to expect\_json\_types [\#59](https://github.com/brooklynDev/airborne/issues/59)

**Fixed bugs:**

- json body rails [\#58](https://github.com/brooklynDev/airborne/issues/58)

**Closed issues:**

- head :no\_content issue [\#57](https://github.com/brooklynDev/airborne/issues/57)
- How send POST request with form data? [\#56](https://github.com/brooklynDev/airborne/issues/56)
- Error on http://brooklyndev.github.io/airborne/ [\#54](https://github.com/brooklynDev/airborne/issues/54)
- How to provide forms parameters for POST? [\#46](https://github.com/brooklynDev/airborne/issues/46)
- Using Airborne with rails-cucumber [\#44](https://github.com/brooklynDev/airborne/issues/44)
- JSON::ParserError [\#43](https://github.com/brooklynDev/airborne/issues/43)
- ENHANCEMENT: Throw error if object called is not present within json\_body [\#42](https://github.com/brooklynDev/airborne/issues/42)

**Merged pull requests:**

- Remove duplicate word and newline in error message [\#60](https://github.com/brooklynDev/airborne/pull/60) ([alcesleo](https://github.com/alcesleo))
- Update README.md [\#55](https://github.com/brooklynDev/airborne/pull/55) ([tit](https://github.com/tit))
- Fix cherry-picking Active Support core extension [\#53](https://github.com/brooklynDev/airborne/pull/53) ([carhartl](https://github.com/carhartl))
- Fix expect\_json in case a property is a hash and keys differ [\#52](https://github.com/brooklynDev/airborne/pull/52) ([carhartl](https://github.com/carhartl))
- unneeded local var assignment [\#51](https://github.com/brooklynDev/airborne/pull/51) ([josephgrossberg](https://github.com/josephgrossberg))
- Update README.md [\#49](https://github.com/brooklynDev/airborne/pull/49) ([Rodney-QAGeek](https://github.com/Rodney-QAGeek))
- Fix headers not passing during rack-test request [\#48](https://github.com/brooklynDev/airborne/pull/48) ([mcordell](https://github.com/mcordell))

## [v0.1.15](https://github.com/brooklynDev/airborne/tree/v0.1.15) (2015-03-03)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.14...v0.1.15)

**Closed issues:**

- upgrade rest-client dependency [\#41](https://github.com/brooklynDev/airborne/issues/41)

**Merged pull requests:**

- Feature: Allowing symbolized statuses to be passed to \#expect\_status matcher [\#38](https://github.com/brooklynDev/airborne/pull/38) ([jgwmaxwell](https://github.com/jgwmaxwell))

## [v0.1.14](https://github.com/brooklynDev/airborne/tree/v0.1.14) (2015-03-02)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.13...v0.1.14)

## [v0.1.13](https://github.com/brooklynDev/airborne/tree/v0.1.13) (2015-03-01)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.12...v0.1.13)

**Closed issues:**

- JSON::ParserError 757 on Post Success [\#39](https://github.com/brooklynDev/airborne/issues/39)

**Merged pull requests:**

- throw InvalidJsonError when accessing json\_body on invalid json request [\#40](https://github.com/brooklynDev/airborne/pull/40) ([sethpollack](https://github.com/sethpollack))

## [v0.1.12](https://github.com/brooklynDev/airborne/tree/v0.1.12) (2015-03-01)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.11...v0.1.12)

**Merged pull requests:**

- Tests fail under RSpec 3.2 due to Airborne\#initialize needing to accept arguments [\#37](https://github.com/brooklynDev/airborne/pull/37) ([jgwmaxwell](https://github.com/jgwmaxwell))

## [v0.1.11](https://github.com/brooklynDev/airborne/tree/v0.1.11) (2015-01-30)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.10...v0.1.11)

**Closed issues:**

- Loading multiple grape apps [\#35](https://github.com/brooklynDev/airborne/issues/35)
- Where is the code for `0.1.10`? [\#34](https://github.com/brooklynDev/airborne/issues/34)
- Expected ? to be array got Hash from JSON response [\#33](https://github.com/brooklynDev/airborne/issues/33)

**Merged pull requests:**

- Enable base header support when testing Rack applications [\#36](https://github.com/brooklynDev/airborne/pull/36) ([croeck](https://github.com/croeck))

## [v0.1.10](https://github.com/brooklynDev/airborne/tree/v0.1.10) (2015-01-08)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.9...v0.1.10)

**Closed issues:**

- undefined method `keys' for nil:NilClass [\#31](https://github.com/brooklynDev/airborne/issues/31)

**Merged pull requests:**

- Fix indention in README.md [\#32](https://github.com/brooklynDev/airborne/pull/32) ([kenchan](https://github.com/kenchan))

## [v0.1.9](https://github.com/brooklynDev/airborne/tree/v0.1.9) (2015-01-05)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.8...v0.1.9)

**Closed issues:**

- How do you get into an array inside an object? [\#30](https://github.com/brooklynDev/airborne/issues/30)
- ActiveSupport dependency [\#27](https://github.com/brooklynDev/airborne/issues/27)

## [v0.1.8](https://github.com/brooklynDev/airborne/tree/v0.1.8) (2014-12-10)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.7...v0.1.8)

**Closed issues:**

- nil json\_body with data in body [\#28](https://github.com/brooklynDev/airborne/issues/28)

## [v0.1.7](https://github.com/brooklynDev/airborne/tree/v0.1.7) (2014-12-10)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.6...v0.1.7)

## [v0.1.6](https://github.com/brooklynDev/airborne/tree/v0.1.6) (2014-12-10)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.5...v0.1.6)

## [v0.1.5](https://github.com/brooklynDev/airborne/tree/v0.1.5) (2014-11-26)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.4...v0.1.5)

**Merged pull requests:**

- Add Head method [\#26](https://github.com/brooklynDev/airborne/pull/26) ([jsvisa](https://github.com/jsvisa))

## [v0.1.4](https://github.com/brooklynDev/airborne/tree/v0.1.4) (2014-11-24)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.3...v0.1.4)

**Closed issues:**

- Update CHANGELOG [\#23](https://github.com/brooklynDev/airborne/issues/23)
- Use of stabby lambda's is breaking jRuby support [\#21](https://github.com/brooklynDev/airborne/issues/21)

**Merged pull requests:**

- Rubygems shouldn't check in Gemfile.lock [\#24](https://github.com/brooklynDev/airborne/pull/24) ([svanhess](https://github.com/svanhess))

## [v0.1.3](https://github.com/brooklynDev/airborne/tree/v0.1.3) (2014-11-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.2...v0.1.3)

## [v0.1.2](https://github.com/brooklynDev/airborne/tree/v0.1.2) (2014-11-16)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.1...v0.1.2)

**Closed issues:**

- Handling of empty arrays [\#19](https://github.com/brooklynDev/airborne/issues/19)
- Feature Request: Add API for testing Array size [\#17](https://github.com/brooklynDev/airborne/issues/17)
- Problem with Dates? [\#16](https://github.com/brooklynDev/airborne/issues/16)
- Testing Arrays [\#15](https://github.com/brooklynDev/airborne/issues/15)
- helper methods for dates [\#14](https://github.com/brooklynDev/airborne/issues/14)

**Merged pull requests:**

- Fix problem with undefined status code method for Rack::MockResponse [\#20](https://github.com/brooklynDev/airborne/pull/20) ([grzesiek](https://github.com/grzesiek))
- Feature/matchers/expect json sizes [\#18](https://github.com/brooklynDev/airborne/pull/18) ([PikachuEXE](https://github.com/PikachuEXE))

## [v0.1.1](https://github.com/brooklynDev/airborne/tree/v0.1.1) (2014-10-20)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.1.0...v0.1.1)

## [v0.1.0](https://github.com/brooklynDev/airborne/tree/v0.1.0) (2014-10-20)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.23...v0.1.0)

**Closed issues:**

- Improper type identification by expect\_json\_types [\#12](https://github.com/brooklynDev/airborne/issues/12)

**Merged pull requests:**

- Fixes problems with configure blocks in README [\#13](https://github.com/brooklynDev/airborne/pull/13) ([cmckni3](https://github.com/cmckni3))

## [v0.0.23](https://github.com/brooklynDev/airborne/tree/v0.0.23) (2014-10-05)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.22...v0.0.23)

**Merged pull requests:**

- Allow matching against a path [\#11](https://github.com/brooklynDev/airborne/pull/11) ([tikotzky](https://github.com/tikotzky))

## [v0.0.22](https://github.com/brooklynDev/airborne/tree/v0.0.22) (2014-09-29)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.21...v0.0.22)

**Closed issues:**

- How to call "expect\_json\_keys" for multiple keys [\#10](https://github.com/brooklynDev/airborne/issues/10)
- array of json objects causes NoMethodError: in base.rb [\#8](https://github.com/brooklynDev/airborne/issues/8)

## [v0.0.21](https://github.com/brooklynDev/airborne/tree/v0.0.21) (2014-09-29)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.20...v0.0.21)

## [v0.0.20](https://github.com/brooklynDev/airborne/tree/v0.0.20) (2014-09-22)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.19...v0.0.20)

**Merged pull requests:**

- Requires only the necessary core\_ext from active\_support. [\#7](https://github.com/brooklynDev/airborne/pull/7) ([cvortmann](https://github.com/cvortmann))

## [v0.0.19](https://github.com/brooklynDev/airborne/tree/v0.0.19) (2014-09-19)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.18...v0.0.19)

**Closed issues:**

- Enable Sourcegraph [\#4](https://github.com/brooklynDev/airborne/issues/4)

**Merged pull requests:**

- 100% Coveralls Code Coverage ;\) [\#6](https://github.com/brooklynDev/airborne/pull/6) ([tikotzky](https://github.com/tikotzky))
- Update README.md [\#5](https://github.com/brooklynDev/airborne/pull/5) ([wykhuh](https://github.com/wykhuh))
- Fix typo on README.md :\) [\#3](https://github.com/brooklynDev/airborne/pull/3) ([mparramont](https://github.com/mparramont))

## [v0.0.18](https://github.com/brooklynDev/airborne/tree/v0.0.18) (2014-09-18)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.17...v0.0.18)

**Merged pull requests:**

- Add syntax highlighting to README [\#1](https://github.com/brooklynDev/airborne/pull/1) ([shekibobo](https://github.com/shekibobo))

## [v0.0.17](https://github.com/brooklynDev/airborne/tree/v0.0.17) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.16...v0.0.17)

## [v0.0.16](https://github.com/brooklynDev/airborne/tree/v0.0.16) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.15...v0.0.16)

## [v0.0.15](https://github.com/brooklynDev/airborne/tree/v0.0.15) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.14...v0.0.15)

## [v0.0.14](https://github.com/brooklynDev/airborne/tree/v0.0.14) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.13...v0.0.14)

## [v0.0.13](https://github.com/brooklynDev/airborne/tree/v0.0.13) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.12...v0.0.13)

## [v0.0.12](https://github.com/brooklynDev/airborne/tree/v0.0.12) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.11...v0.0.12)

## [v0.0.11](https://github.com/brooklynDev/airborne/tree/v0.0.11) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.10...v0.0.11)

## [v0.0.10](https://github.com/brooklynDev/airborne/tree/v0.0.10) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.9...v0.0.10)

## [v0.0.9](https://github.com/brooklynDev/airborne/tree/v0.0.9) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.8...v0.0.9)

## [v0.0.8](https://github.com/brooklynDev/airborne/tree/v0.0.8) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.7...v0.0.8)

## [v0.0.7](https://github.com/brooklynDev/airborne/tree/v0.0.7) (2014-09-17)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.6...v0.0.7)

## [v0.0.6](https://github.com/brooklynDev/airborne/tree/v0.0.6) (2014-09-16)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.5...v0.0.6)

## [v0.0.5](https://github.com/brooklynDev/airborne/tree/v0.0.5) (2014-09-16)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.4...v0.0.5)

## [v0.0.4](https://github.com/brooklynDev/airborne/tree/v0.0.4) (2014-09-16)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.3...v0.0.4)

## [v0.0.3](https://github.com/brooklynDev/airborne/tree/v0.0.3) (2014-09-16)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.2...v0.0.3)

## [v0.0.2](https://github.com/brooklynDev/airborne/tree/v0.0.2) (2014-09-16)
[Full Changelog](https://github.com/brooklynDev/airborne/compare/v0.0.1...v0.0.2)

## [v0.0.1](https://github.com/brooklynDev/airborne/tree/v0.0.1) (2014-09-16)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
