module Synchronizers
  class BaseSynchronizer < BaseService
    include HTTParty

    class_attribute :serializer_class_name

    def initialize(*args)
      @args = args
      @service = ApiClients::KiotvietClient.call
    end

    def call
      sync
    end

    def sync
      Synchronizers::Flexzen.api_request(:post, @args.last + "/import/json", body: @args.first)
    end

    def headers_config
      {
        "Retailer": "Fascom",
        "Authorization": "Bearer" + " " + "#{@service.result['access_token']}",
        'Accept-Encoding' => ''
      }
    end

    def data_serializer(object, branch)
      hash = serializer_class_name.constantize.new(object, branch).as_json
    end
  end
end
