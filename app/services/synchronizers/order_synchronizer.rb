module Synchronizers
  class OrdersSynchronizer < BaseSynchronizer

    self.serializer_class_name = "::Synchronizers::OrderSerializer"

    def call
      data = get_data_kiotviet
      data_serializer = data_serializer(data)
      Synchronizers::BaseSynchronizer.call(data_serializer, path)
    end

    private

    def data_serializer(object)
      data = object["data"]
      hash = serializer_class_name.constantize.new(data).as_json
    end

    def get_data_kiotviet
      response = HTTParty.get(get_data_kiot_path, headers: headers_config)
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : { status: response.code }
    end

    def get_data_kiot_path
      "#{ENV['KIOTVIET_API_ENDPOINT']}/invoices"
    end

    def path
      "/#{ENV['FLEXZEN_API_ORDERS']}"
    end
  end
end
