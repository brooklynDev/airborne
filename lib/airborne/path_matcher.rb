module Airborne
	module PathMatcher
		def get_by_path(path, json)
			parts = path.split('.')
			parts.each do |part|
				if /^[\d]+(\.[\d]+){0,1}$/ === part
					part = part.to_i
					json = json[part]
				else
					json = json[part.to_sym]	
				end
			end
			yield json
		end
	end
end