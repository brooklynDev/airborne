module Airborne
  module RequestMethods
    attr_reader :response

    def get(url, headers = nil, verify_ssl = base_verify_ssl)
      @response = make_request(:get, url, headers: headers, verify_ssl: verify_ssl)
    end

    def post(url, post_body = nil, headers = nil, verify_ssl = base_verify_ssl)
      @response = make_request(:post, url, body: post_body, headers: headers, verify_ssl: verify_ssl)
    end

    def patch(url, patch_body = nil, headers = nil, verify_ssl = base_verify_ssl)
      @response = make_request(:patch, url, body: patch_body, headers: headers, verify_ssl: verify_ssl)
    end

    def put(url, put_body = nil, headers = nil, verify_ssl = base_verify_ssl)
      @response = make_request(:put, url, body: put_body, headers: headers, verify_ssl: verify_ssl)
    end

    def delete(url, delete_body = nil, headers = nil, verify_ssl = base_verify_ssl)
      @response = make_request(:delete, url, body: delete_body, headers: headers, verify_ssl: verify_ssl)
    end

    def head(url, headers = nil)
      @response = make_request(:head, url, headers: headers)
    end

    def options(url, headers = nil)
      @response = make_request(:options, url, headers: headers)
    end
  end
end
