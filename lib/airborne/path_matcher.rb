module Airborne
  module PathMatcher
    def get_by_path(path, json, &block)
      type = false
      parts = path.split('.')
      parts.each_with_index do |part, index|
        if part == '*' || part == '?'
          type = part
          raise "Expected #{path} to be array got #{json.class} from JSON response" unless json.class == Array
          if index < parts.length.pred
            json.each do |element|
              sub_path = parts[(index.next)...(parts.length)].join('.')
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
          raise "Expected #{path} to be object or array got #{json.class} from JSON response" unless [Array, Hash, NilClass].include?(json.class)
        end
      end
      if type == '*'
        json.each{|part| yield part}
      elsif type == '?'
        item_count = json.length
        error_count = 0
        json.each do |part|
          begin
            yield part
          rescue Exception => e
            error_count += 1
            raise "Expected one object in path #{path} to match provided JSON values" if item_count == error_count
          end
        end
      else
        yield json
      end
    end
  end
end
