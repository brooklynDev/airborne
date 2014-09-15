module Airborne
	module PathMatcher
		def get_by_path(path, json)
			parts = path.split('.')
			parts.each do |part|
				json = json[part.to_sym]
			end
			yield json
		end
	end
end