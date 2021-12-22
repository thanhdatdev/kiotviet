module Synchronizers
  class BaseSynchronizer < BaseService
    include HTTParty

    class_attribute :serializer_class_name

    def initialize(*args)
      @args = args
    end

    def call
      sync
    end

    def sync
      byebug
      Synchronizers::Flexzen.api_request(:post, @args.last + "/import/json", body: @args.first)
    end

    def headers_config
      {
        "Retailer": "Fascom",
        "Authorization": "Bearer" + " " + "#{ENV['ACCESS_TOKEN']}",
        'Accept-Encoding' => ''
      }
    end
  end
end
