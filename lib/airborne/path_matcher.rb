module Airborne
	module PathMatcher
		def get_by_path(path, json, &block)
			parts = path.split('.')
			parts.each_with_index do |part, index|
				if part == '*'
					raise "Expected #{path} to be array got #{json.class} from JSON response" unless json.class == Array
					if index < parts.length - 1
						json.each do |element|
							sub_path = parts[(index + 1)..(parts.length-1)].join('.')
							get_by_path(sub_path, element, &block)
						end
						return
					end
					next
				end
				if /^[\d]+(\.[\d]+){0,1}$/ === part
					part = part.to_i
					json = json[part]
				else
					json = json[part.to_sym]
					raise "Expected #{path} to be object or array got #{json.class} from JSON response" unless json.class == Array || json.class == Hash
				end
			end
			if json.class == Array
				json.each{|part| yield part}
			else
				yield json
			end
		end
	end
end