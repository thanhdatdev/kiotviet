module Synchronizers
  class UnitSerializer < BaseSerializer
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def as_json
      hash = []
      data.each do |obj|
        hash << {
          'ma_vt' =>  obj['code'],
          'ten_vt' => obj['fullName'],
          'ten_nvt' => obj['categoryName'],
          'gia_ban_le' => obj['basePrice'],
          'ma_dvt' => obj['unit']
        }
      end
      hash
    end
  end
end
