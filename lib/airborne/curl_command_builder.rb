require 'shellwords'

module Airborne
  module CurlCommandBuilder

    def curl_command
      [
        'curl -v',
        ['-d', @request_body].shelljoin,
        "-X#{@method.to_s.upcase}",
        build_headers(@headers),
        get_url(@url)
      ].join ' '
    end

    private

    def build_headers(headers)
      base_headers.merge(headers).map { |header, value|
        header = header.to_s.split('_').map(&:capitalize).join('-')
        [
          '-H',
          "\"#{header}: #{value}\""
        ].shelljoin
      }.join ' '
    end
  end
end
