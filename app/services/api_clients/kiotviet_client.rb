  module ApiClients
    class KiotvietClient < BaseService
      include HTTParty

      def call
        @result = http_request
      end

      def http_request
        response = HTTParty.post(path, body: body, headers: headers_config)
        response_hash = response.body.present? ? JSON.parse(response.body.to_s) : { status: response.code }
      end

      def body
        {
          "client_id" => "#{ENV['CLIENT_ID']}",
          "client_secret" => "#{ENV['CLIENT_SECRET']}",
          "scopes" => "PublicApi.Access",
          "grant_type" => "client_credentials"
        }
      end

      def headers_config
        {
          "Content-Type": 'application/x-www-form-urlencoded'
        }
      end

      private

      def path
        "#{ENV['GET_ACCESS_TOKEN_KIOTVIET_ENDPOINT']}"
      end
    end
  end
