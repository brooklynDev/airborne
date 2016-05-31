require 'rest_client'
require 'json-schema-generator'

module Airborne
  module RestClientRequester
    def make_request(method, url, options = {})
      headers = base_headers.merge(options[:headers] || {})
      if method == :post || method == :patch || method == :put
        begin
          request_body = options[:body].nil? ? '' : options[:body]
          request_body = request_body.to_json if options[:body].is_a?(Hash)
          res = RestClient.send(method, get_url(url), request_body, headers)
          generate_json(method, url, res) if Airborne.configuration.validate_schema
        rescue RestClient::Exception => e
          res = e.response
        end
      else
        begin
          res = RestClient.send(method, get_url(url), headers)
          generate_json(method, url, res) if Airborne.configuration.validate_schema
        rescue RestClient::Exception => e
          res = e.response
        end
      end
      res
    end

    private

    def base_headers
      { content_type: :json }.merge(Airborne.configuration.headers || {})
    end

    def generate_json(method, url, res)
      path = "#{Dir.pwd}/#{Airborne.configuration.schema_path}#{url}"
      path = path.tr('?', '/').tr('&', '/').tr('[', '-').tr(']', '')
      path = path.gsub(/\/\d*\//, "/ID/").gsub(/\/\d*$/, "/ID").tr('=', '/')

      file = "#{path}/#{method}.json"

      unless File.exist?(file.gsub('.json', '.schema'))
        return unless Airborne.configuration.generate_schema # no schema to compare against
        FileUtils.mkdir_p(path)
      end

      File.open(file, 'w') { |f| f.puts res }

      schema_file = file.gsub(".json", ".schema")
      return if File.exist?(schema_file) && !Airborne.configuration.generate_schema

      schema = JSON::SchemaGenerator.generate file, File.read(file), {:schema_version => Airborne.configuration.schema_version}
      File.open(schema_file, 'w') { |f| f.puts schema }
    end
  end
end
