module Synchronizers
  class UsersSynchronizer < BaseSynchronizer

    self.serializer_class_name = "::Synchronizers::UserSerializer"

    def call
      data = get_data_kiotviet
      data_serializer = data_serializer(data)
      Synchronizers::BaseSynchronizer.call(data_serializer, path)
    end

    private

    def get_data_kiotviet
      response = HTTParty.get(get_data_kiot_path, headers: headers_config)
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : { status: response.code }
      response_hash['data']
    end

    def get_data_kiot_path
      "#{ENV['KIOTVIET_API_ENDPOINT']}/customers"
    end

    def path
      "/#{ENV['FLEXZEN_API_PRODUCTS']}"
    end
  end
end
