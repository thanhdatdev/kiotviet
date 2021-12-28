module Synchronizers
  class Flexzen
    def self.request(method, path, body: nil, return_errors: false)
      url = url(path)
      args = [method.to_sym, url]
      args << { json: body } if body
      response = HTTP.request(*args)
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : { status: response.code }
      puts JSON.pretty_generate(JSON.parse(response.body.to_s))
      unless (200..299).cover?(response.code)
        return Synchronizers::Error.new(
          request_method: method,
          request_url: url,
          request_body: body,
          status: response_hash["status"] || response.code,
          response_hash: response_hash
        ).tap { |error| raise error unless return_errors }
      end

      response_hash
    rescue JSON::ParserError => e
      return Synchronizers::Error.new(request_method: method, request_url: url, request_body: body,
                      status: response.status, detail: "JSON::ParserError #{e}",
                      response_body: response.body.to_s).tap { |error| raise error unless return_errors }
    end

    def self.api_request(method, path, body: nil, return_errors: false)
      path = "/api" + path
      request(method, path, body: body, return_errors: return_errors)
    end

    def self.base_url
      "#{ENV['FLEXZEN_API_ENDPOINT']}"
    end

    def self.url(path)
      base_url + path + "?access_token=#{ENV['ACCESS_TOKEN_FLEXZEN']}" + "&update=true"
    end
  end
end
