# frozen_string_literal: true

module Airborne
  class OptionalHashTypeExpectations
    include Enumerable
    attr_accessor :hash

    def initialize(hash)
      @hash = hash
    end

    def each(&block)
      @hash.each(&block)
    end

    def [](val)
      @hash[val]
    end

    def keys
      @hash.keys
    end
  end
end
