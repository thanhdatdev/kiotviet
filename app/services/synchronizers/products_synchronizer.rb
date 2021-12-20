module Synchronizers
  class ProductsSynchronizer < BaseSynchronizer

    self.serializer_class_name = "::Synchronizers::ProductSerializer"

    def call
      data = get_data_kiotviet
      data_serializer = data_serializer(data)
      Synchronizers::BaseSynchronizer.call(data_serializer, path)
    end

    private

    def data_serializer(object)
      data = object["data"]
      hash = serializer_class_name.constantize.new(data).serializable_hash
    end

    def get_data_kiotviet
      response = HTTParty.get(path, headers: headers_config)
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : { status: response.code }
    end

    def path
      "#{ENV['KIOTVIET_API_ENDPOINT']}/Products"
    end
  end
end
