# frozen_string_literal: true

require 'rspec'
require 'date'
require 'rack/utils'

module Airborne
  class ExpectationError < StandardError; end

  module RequestExpectations
    include RSpec
    include PathMatcher

    def expect_json_types(*args)
      call_with_path(args) do |param, body|
        expect_json_types_impl(param, body)
      end
    end

    def expect_json(*args)
      call_with_path(args) do |param, body|
        expect_json_impl(param, body)
      end
    end

    def expect_json_keys(*args)
      call_with_path(args) do |param, body|
        expect(body.keys).to include(*param)
      end
    end

    def expect_json_sizes(*args)
      args.push(convert_expectations_for_json_sizes(args.pop))

      expect_json_types(*args)
    end

    def expect_status(code)
      expect(response.code).to eq(resolve_status(code, response.code))
    end

    def expect_header(key, content)
      expect_header_impl(key, content)
    end

    def expect_header_contains(key, content)
      expect_header_impl(key, content, true)
    end

    def optional(hash)
      OptionalHashTypeExpectations.new(hash)
    end

    def regex(reg)
      Regexp.new(reg)
    end

    def date
      ->(value) { yield DateTime.parse(value) }
    end

    private

    def expect_header_impl(key, content, contains = nil)
      header = headers[key]
      raise RSpec::Expectations::ExpectationNotMetError, "Header #{key} not present in the HTTP response" unless header

      if contains
        expect(header.downcase).to include(content.downcase)
      else
        expect(header.downcase).to eq(content.downcase)
      end
    end

    def expect_json_impl(expected, actual)
      return if nil_optional_hash?(expected, actual)

      actual = actual.to_s if expected.is_a?(Regexp)

      return expect(actual).to match(expected) if property?(expected)

      keys = []

      keys << expected.keys if match_expected?
      keys << actual.keys if match_actual?
      keys = expected.keys & actual.keys if match_none?

      keys.flatten.uniq.each do |prop|
        expected_value = extract_expected_value(expected, prop)
        actual_value = extract_actual(actual, prop)

        next expect_json_impl(expected_value, actual_value) if hash?(expected_value) && hash?(actual_value)
        next expected_value.call(actual_value) if expected_value.is_a?(Proc)
        next expect(actual_value.to_s).to match(expected_value) if expected_value.is_a?(Regexp)

        expect(actual_value).to eq(expected_value)
      end
    end

    def expect_json_types_impl(expected, actual)
      return if nil_optional_hash?(expected, actual)

      @mapper ||= mapper

      actual = convert_to_date(actual) if (expected == :date) || (expected == :date_or_null)

      return expect_type(expected, actual) if expected.is_a?(Symbol)
      return expected.call(actual) if expected.is_a?(Proc)

      keys = []

      keys << expected.keys if match_expected?
      keys << actual.keys if match_actual?
      keys = expected.keys & actual.keys if match_none?

      keys.flatten.uniq.each do |prop|
        type = extract_expected_type(expected, prop)
        value = extract_actual(actual, prop)
        value = convert_to_date(value) if (type == :date) || (type == :date_or_null)

        next expect_json_types_impl(type, value) if hash?(type)
        next type.call(value) if type.is_a?(Proc)

        type_string = type.to_s

        if type_string.include?('array_of') && !(type_string.include?('or_null') && value.nil?)
          check_array_types(value, prop, type)
        else
          expect_type(type, value, prop)
        end
      end
    end

    def call_with_path(args)
      if args.length == 2
        get_by_path(args[0], json_body) do |json_chunk|
          yield(args[1], json_chunk)
        end
      else
        yield(args[0], json_body)
      end
    end

    def extract_expected_value(expected, prop)
      raise unless expected.key?(prop)

      expected[prop]
    rescue StandardError
      raise ExpectationError, "Expectation is expected to contain property: #{prop}"
    end

    def extract_expected_type(expected, prop)
      type = expected[prop]
      type.nil? ? raise : type
    rescue StandardError
      raise ExpectationError, "Expectation is expected to contain property: #{prop}"
    end

    def extract_actual(actual, prop)
      actual[prop]
    rescue StandardError
      raise ExpectationError, "Expected #{actual.class} #{actual}\nto be an object with property #{prop}"
    end

    def expect_type(expected_type, value, prop_name = nil)
      raise ExpectationError, "Expected type #{expected_type}\nis an invalid type" if @mapper[expected_type].nil?

      insert = prop_name.nil? ? '' : "#{prop_name} to be of type"
      message = "Expected #{insert} #{expected_type}\n got #{value.class} instead"

      expect(@mapper[expected_type].any? { |type| value.is_a?(type) }).to eq(true), message
    end

    def convert_to_date(value)
      DateTime.parse(value)
    rescue StandardError
      nil
    end

    def check_array_types(value, prop_name, expected_type)
      expect_array(value, prop_name, expected_type)
      value.each do |val|
        expect_type(expected_type, val, prop_name)
      end
    end

    def nil_optional_hash?(expected, hash)
      expected.is_a?(Airborne::OptionalHashTypeExpectations) && hash.nil?
    end

    def hash?(hash)
      hash.is_a?(Hash) || hash.is_a?(Airborne::OptionalHashTypeExpectations)
    end

    def expect_array(value, prop_name, expected_type)
      expect(value.class).to eq(Array),
                             "Expected #{prop_name}\n to be of type #{expected_type}\n got #{value.class} instead"
    end

    def convert_expectations_for_json_sizes(old_expectations)
      return convert_expectation_for_json_sizes(old_expectations) unless old_expectations.is_a?(Hash)

      old_expectations.each_with_object({}) do |(prop_name, expected_size), memo|
        new_value = if expected_size.is_a?(Hash)
                      convert_expectations_for_json_sizes(expected_size)
                    else
                      convert_expectation_for_json_sizes(expected_size)
                    end
        memo[prop_name] = new_value
      end
    end

    def convert_expectation_for_json_sizes(expected_size)
      ->(data) { expect(data.size).to eq(expected_size) }
    end

    def ensure_hash_contains_prop(prop_name, hash)
      yield
    rescue StandardError
      raise ExpectationError, "Expected #{hash.class} #{hash}\nto be an object with property #{prop_name}"
    end

    def property?(expectation)
      [String, Regexp, Float, Integer, TrueClass, FalseClass, NilClass, Array].any? { |type| expectation.is_a?(type) }
    end

    def mapper
      base_mapper = {
        integer: [Integer],
        array_of_integers: [Integer],
        int: [Integer],
        array_of_ints: [Integer],
        float: [Float, Integer],
        array_of_floats: [Float, Integer],
        string: [String],
        array_of_strings: [String],
        boolean: [TrueClass, FalseClass],
        array_of_booleans: [TrueClass, FalseClass],
        bool: [TrueClass, FalseClass],
        array_of_bools: [TrueClass, FalseClass],
        object: [Hash],
        array_of_objects: [Hash],
        array: [Array],
        array_of_arrays: [Array],
        date: [DateTime],
        null: [NilClass]
      }

      mapper = base_mapper.clone
      base_mapper.each do |key, value|
        mapper["#{key}_or_null".to_sym] = value + [NilClass]
      end
      mapper
    end

    def resolve_status(candidate, authority)
      candidate = Rack::Utils::SYMBOL_TO_STATUS_CODE[candidate] if candidate.is_a?(Symbol)
      case authority
      when String then candidate.to_s
      when Integer then candidate.to_i
      else candidate
      end
    end

    def match_none?
      !match_actual? && !match_expected?
    end

    def match_actual?
      Airborne.configuration.match_actual?
    end

    def match_expected?
      Airborne.configuration.match_expected?
    end
  end
end
