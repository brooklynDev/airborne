require 'rspec'

module RequestExpectations
	include RSpec

	def expectJSONTypes(expectations)
		expectJSONTypesImpl(expectations, body)
	end

	def expectJSON(expectations)
		expectJSONImpl(expectations, body)
	end

	def expectStatus(code)
		expect(response.code).to eq(code)
	end

	private

		def get_mapper
			base_mapper = {
				integer: [Fixnum,Bignum],
				int: [Fixnum,Bignum],
				float: [Float],
				string: [String],
				boolean: [TrueClass, FalseClass],
				bool: [TrueClass, FalseClass],
				object: [Hash],
				array: [Array]
			}

			mapper = base_mapper.clone
			base_mapper.each do |key, value|
				mapper[(key.to_s + "_or_null").to_sym] = value + [NilClass]
			end
			mapper
		end

		def expectJSONTypesImpl(expectations, hash)
			@mapper ||= get_mapper
			expectations.each do |prop_name, value|
				val = hash[prop_name]
				if val.class == Hash
					expectJSONTypesImpl(value, val)
				else
					expect(@mapper[value].include?(val.class)).to eq(true), "Expected #{prop_name} to be of type #{value}, got #{val.class} instead"
				end
			end			
		end

		def expectJSONImpl(expectations, hash)
			expectations.each do |prop_name, value|
				val = hash[prop_name]
				if(val.class == Hash)
					expectJSONImpl(value, val)
				else
					expect(value).to eq(val)
				end
			end
		end
end