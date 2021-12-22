  module ApiClients
    class KiotvietClient < BaseService
      include HTTParty

      attr_reader :params

      def initialize(params)
        @params = params
      end

      def call
        http_request
      end

      def http_request
        byebug
        HTTParty.post(path, body: body, headers: headers_config)
      end

      def body
        {
          # "client_id" => "#{params[:session][:client_id]}",
          # "client_secret" => "#{params[:session][:client_serect]}",
          "client_id" => "#{ENV['CLIENT_ID']}",
          "client_secret" => "#{ENV['CLIENT_SECRET']}",
          "grant_type" => "client_credentials",
          "scopes" =>  "PublicApi.Access"
        }
      end

      def headers_config
        {
          "Content-Length": '1000',
          "Content-Type": 'application/x-www-form-urlencoded',
          "Accept-Encoding": ''
        }
      end

      private

      def path
        "#{ENV['GET_ACCESS_TOKEN_KIOTVIET_ENDPOINT']}"
      end
    end
  end
