module Synchronizers
  class BaseSynchronizer < BaseService
    include HTTParty

    class_attribute :serializer_class_name

    attr_reader :data, :path

    def initialize(*args)
      @args = args
    end

    def call
      sync
    end

    def headers_config
      {
        "Retailer": "Fascom",
        "Authorization": "Bearer" + " " + "#{ENV['ACCESS_TOKEN']}",
        'Accept-Encoding' => ''
      }
    end

    def sync
      byebug
      Synchronizers::Kiotviet.api_request(:post, @args.last, headers: headers_config, body: data)
    end
  end
end
