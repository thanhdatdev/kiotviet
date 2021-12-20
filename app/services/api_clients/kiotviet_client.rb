  module ApiClients
    class KiotvietClient < BaseService
      include HTTParty

      def call
        debugger
        http_request
      end

      def http_request
        HTTParty.post(path, body: body.to_json, headers: headers_config)
      end

      def body
        {
          "client_id" => "#{ENV['CLIENT_ID']}",
          "client_serect" => "#{ENV['CLIENT_SERECT']}",
          "grant_type" => "client_credentials",
          "scopes" => "PublicApi.Access"
        }
      end

      def headers_config
        { "Content-Type": 'application/x-cwww-form-urlencoded' }
      end

      private

      def path
        "#{ENV['KIOTVIET_API_ENDPOINT']}/connect/token"
      end
    end
  end
