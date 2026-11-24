require 'active_support/core_ext/hash/indifferent_access'

module Airborne
  class ResponseHeaders < ActiveSupport::HashWithIndifferentAccess
    private

    def convert_key(key)
      key.to_s.downcase.tr('-', '_')
    end
  end
end
