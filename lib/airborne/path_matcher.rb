# frozen_string_literal: true

module Airborne
  class PathError < StandardError; end

  module PathMatcher
    WILDCARDS = ['*', '?'].freeze

    def get_by_path(path, json, &block) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
      raise PathError, "Invalid Path, contains '..'" if /\.\./.match?(path)

      type = false
      parts = path.split('.')
      exit_now = false
      parts.each_with_index do |part, index|
        if WILDCARDS.include?(part)
          ensure_array(path, json)
          type = part

          if index < parts.length.pred
            walk_with_path(type, index, path, parts, json, &block)
            exit_now = true
            break
          end

          next
        end

        begin
          json = process_json(part, json)
        rescue StandardError
          raise PathError, "Expected #{json.class}\nto be an object with property #{part}"
        end
      end

      return if exit_now

      case type
      when '*'
        expect_all(json, &block)
      when '?'
        expect_one(path, json, &block)
      else
        yield json
      end
    end

    private

    def walk_with_path(type, index, path, parts, json, &block) # rubocop:disable Metrics/MethodLength
      last_error = nil
      item_count = json.length
      error_count = 0
      json.each do |element|
        begin
          sub_path = parts[(index.next)...(parts.length)].join('.')
          get_by_path(sub_path, element, &block)
        rescue Exception => e # rubocop:disable Lint/RescueException
          last_error = e
          error_count += 1
        end
        ensure_match_all(last_error) if type == '*'
        ensure_match_one(path, item_count, error_count) if type == '?'
      end
    end

    def process_json(part, json)
      if index?(part) && json.is_a?(Array)
        part = part.to_i
        json = json[part]
      else
        json = json[part.to_sym]
      end
      json
    end

    def index?(part)
      part =~ /^\d+$/
    end

    def expect_one(path, json)
      item_count = json.length
      error_count = 0
      json.each do |part|
        yield part
      rescue Exception # rubocop:disable Lint/RescueException
        error_count += 1
        ensure_match_one(path, item_count, error_count)
      end
    end

    def expect_all(json, &block)
      last_error = nil
      begin
        json.each(&block)
      rescue Exception => e # rubocop:disable Lint/RescueException
        last_error = e
      end
      ensure_match_all(last_error)
    end

    def ensure_match_one(path, item_count, error_count)
      return unless item_count == error_count

      raise RSpec::Expectations::ExpectationNotMetError,
            "Expected one object in path #{path} to match provided JSON values"
    end

    def ensure_match_all(error)
      raise error unless error.nil?
    end

    def ensure_array(path, json)
      return if json.is_a?(Array)

      raise RSpec::Expectations::ExpectationNotMetError,
            "Expected #{path} to be array got #{json.class} from JSON response"
    end
  end
end
