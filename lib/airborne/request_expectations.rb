require 'rspec'

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

    def expect_status(code)
      expect(response.code).to eq(code)
    end

    def expect_header(key, content)
      header = headers[key]
      if header
        expect(header.downcase).to eq(content.downcase)
      else
        raise "Header #{key} not present in HTTP response"
      end
    end

    def expect_header_contains(key, content)
      header = headers[key]
      if header
        expect(header.downcase).to include(content.downcase)
      else
        raise "Header #{key} not present in HTTP response"
      end
    end

    def optional(hash)
      OptionalHashTypeExpectations.new(hash)
    end

    def regex(reg)
      Regexp.new(reg)
    end

    [:expect_json_types, :expect_json, :expect_json_keys, :expect_status, :expect_header, :expect_header_contains].each do |method_name|
      method = instance_method(method_name)
      define_method(method_name) do |*args, &block|
        set_rails_response
        method.bind(self).(*args, &block)
      end
    end

    private

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
        array_of_arrays: [Array]
      }

      mapper = base_mapper.clone
      base_mapper.each do |key, value|
        mapper[(key.to_s + "_or_null").to_sym] = value + [NilClass]
      end
      mapper
    end

    def expect_json_types_impl(expectations, hash)
      return if expectations.class == Airborne::OptionalHashTypeExpectations && hash.nil?
      @mapper ||= get_mapper
      return expect(@mapper[expectations].include?(hash.class)).to eq(true) if expectations.class == Symbol
      expectations.each do |prop_name, expected_type|
        value = hash[prop_name]
        if expected_type.class == Hash || expected_type.class ==  Airborne::OptionalHashTypeExpectations
          expect_json_types_impl(expected_type, value)
        elsif expected_type.class == Proc
          expected_type.call(value)
        elsif expected_type.to_s.include?("array_of")
          expect(value.class).to eq(Array), "Expected #{prop_name} to be of type #{expected_type}, got #{value.class} instead"
          value.each do |val|
            expect(@mapper[expected_type].include?(val.class)).to eq(true), "Expected #{prop_name} to be of type #{expected_type}, got #{val.class} instead"
          end
        else
          expect(@mapper[expected_type].include?(value.class)).to eq(true), "Expected #{prop_name} to be of type #{expected_type}, got #{value.class} instead"
        end
      end
    end

    def expect_json_impl(expectations, hash)
      hash = hash.to_s if expectations.class == Regexp
      return expect(hash).to match(expectations) if [String, Regexp, Float, Fixnum, Bignum].include?(expectations.class)
      expectations.each do |prop_name, expected_value|
        actual_value = hash[prop_name]
        if expected_value.class == Hash
          expect_json_impl(expected_value, actual_value)
        elsif expected_value.class == Proc
          expected_value.call(actual_value)
        elsif expected_value.class == Regexp
          expect(actual_value.to_s).to match(expected_value)
        else
          expect(actual_value).to eq(expected_value)
        end
      end
    end
  end
end
