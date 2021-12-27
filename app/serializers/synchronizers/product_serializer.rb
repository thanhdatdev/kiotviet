module Synchronizers
  class ProductSerializer < BaseSerializer
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def as_json
      hash = []
      data.each do |obj|
        dvt = 'Cái'
        hash << {
          'ma_vt' =>  obj['code'].to_s,
          'ten_vt' => obj['fullName'],
          'ten_nvt' => obj['categoryName'],
          'gia_ban_le' => obj['basePrice'],
          "ma_dvt" => obj['unit'] if obj['unit'].present? : dvt,
          'ma_lvt' => "TP",
          'tg_tk' =>  true,
          'tk_vt' => "1561",
          'tk_dt' => "51112",
          'tk_gv' => "6321"
        }
      end
      hash
    end
  end
end
