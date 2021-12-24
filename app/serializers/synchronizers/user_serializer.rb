module Synchronizers
  class UserSerializer < BaseSerializer
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def as_json
      hash = []
      data.each do |obj|
        hash << {
          'ma_kh' =>  obj['code'],
          'ten_kh' => obj['name'],
          'gioi_tinh' => obj['gender'],
          'ngay_sinh' => obj['birthDate'],
          'dien_thoai' => obj['contactNumber'],
          'dia_chi' => obj['address'],
          'email' => obj['email'],
        }
      end
      hash
    end
  end
end
