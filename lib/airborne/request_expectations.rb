require 'rspec'
require 'date'

module Airborne
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
      expect(response.code).to eq(code)
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
      lambda {|value| yield DateTime.parse(value)}
    end

    [:expect_json_types, :expect_json, :expect_json_keys, :expect_status, :expect_header, :expect_header_contains].each do |method_name|
      method = instance_method(method_name)
      define_method(method_name) do |*args, &block|
        set_rails_response
        method.bind(self).(*args, &block)
      end
    end

    private

    def expect_header_impl(key, content, contains = nil)
      header = headers[key]
      if header
        if contains
          expect(header.downcase).to include(content.downcase)
        else
          expect(header.downcase).to eq(content.downcase)
        end
      else
        raise RSpec::Expectations::ExpectationNotMetError, "Header #{key} not present in HTTP response"
      end
    end

    def set_rails_response
      set_response(@response) if @json_body.nil?
    end

    def call_with_path(args)
      if args.length == 2
        get_by_path(args[0], json_body) do|json_chunk|
          yield(args[1], json_chunk)
        end
      else
        yield(args[0], json_body)
      end
    end

    def get_mapper
      base_mapper = {
        integer: [Fixnum,Bignum],
        array_of_integers: [Fixnum,Bignum],
        int: [Fixnum,Bignum],
        array_of_ints: [Fixnum,Bignum],
        float: [Float,Fixnum,Bignum],
        array_of_floats: [Float,Fixnum,Bignum],
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
        date: [DateTime]
      }

      mapper = base_mapper.clone
      base_mapper.each do |key, value|
        mapper[(key.to_s + "_or_null").to_sym] = value + [NilClass]
      end
      mapper
    end

    def expect_json_types_impl(expectations, hash_or_value)
      return if is_nil_optional_hash?(expectations, hash_or_value)

      @mapper ||= get_mapper

      hash_or_value = convert_to_date(hash_or_value) if expectations == :date

      return expect_type(expectations, hash_or_value.class) if expectations.class == Symbol
      return expectations.call(hash_or_value) if expectations.class == Proc

      expectations.each do |prop_name, expected_type|
        value = expected_type == :date ? convert_to_date(hash_or_value[prop_name]) : hash_or_value[prop_name]
        expected_class = expected_type.class
        value_class = value.class

        next expect_json_types_impl(expected_type, value) if is_hash?(expected_class)
        next expected_type.call(value) if expected_class == Proc

        if expected_type.to_s.include?("array_of")
          check_array_types(value, value_class, prop_name, expected_type)
        else
          expect_type(expected_type, value_class, prop_name)
        end
      end
    end

    def convert_to_date(value)
      begin
        value = DateTime.parse(value)
      rescue
      end
    end

    def check_array_types(value, value_class, prop_name, expected_type)
      expect_array(value_class, prop_name, expected_type)
      value.each do |val|
        expect_type(expected_type, val.class, prop_name)
      end
    end

    def is_nil_optional_hash?(expectations, hash)
      expectations.class == Airborne::OptionalHashTypeExpectations && hash.nil?
    end

    def expect_type(expected_type, value_class, prop_name = nil)
      insert = prop_name.nil? ? "" : "#{prop_name} to be of type"
      msg = "Expected #{insert} #{expected_type}\n, got #{value_class} instead"
      expect(@mapper[expected_type].include?(value_class)).to eq(true), msg
    end

    def is_hash?(expected_class)
      expected_class == Hash || expected_class ==  Airborne::OptionalHashTypeExpectations
    end

    def expect_array(value_class, prop_name, expected_type)
      expect(value_class).to eq(Array), "Expected #{prop_name}\n to be of type #{expected_type}\n, got #{value_class} instead"
    end

    def expect_json_impl(expectations, hash)
      hash = hash.to_s if expectations.class == Regexp
      return expect(hash).to match(expectations) if is_property?(expectations)
      expectations.each do |prop_name, expected_value|
        actual_value = hash[prop_name]
        expected_class = expected_value.class
        next expect_json_impl(expected_value, actual_value) if expected_class == Hash
        next expected_value.call(actual_value) if expected_class == Proc
        next expect(actual_value.to_s).to match(expected_value) if expected_class == Regexp
        expect(actual_value).to eq(expected_value)
      end
    end

    # Convert integers in `old_expectations` to proc
    #
    # @param old_expectations [Hash]
    def convert_expectations_for_json_sizes(old_expectations)
      unless old_expectations.is_a?(Hash)
        return convert_expectation_for_json_sizes(old_expectations)
      end

      old_expectations.each_with_object({}) do |(prop_name, expected_size), memo|
        new_value = if expected_size.is_a?(Hash)
                      convert_expectations_for_json_sizes(expected_size)
                    else
                      convert_expectation_for_json_sizes(expected_size)
                    end
        memo[prop_name] = new_value
      end
    end

    # @param expected_size [Integer]
    # @return [Proc]
    def convert_expectation_for_json_sizes(expected_size)
      -> (data) { expect(data.size).to eq(expected_size) }
    end

    def is_property?(expectations)
      [String, Regexp, Float, Fixnum, Bignum, TrueClass, FalseClass, NilClass].include?(expectations.class)
    end

  end
end
