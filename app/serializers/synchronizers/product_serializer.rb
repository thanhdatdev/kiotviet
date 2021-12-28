module Synchronizers
  class ProductSerializer < BaseSerializer
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def as_json
      hash = []
      dvt = 'Cái'
      data.each do |obj|
        body = {
          'ma_vt' =>  obj['code'].to_s,
          'ten_vt' => obj['fullName'],
          'ten_nvt' => obj['categoryName'],
          'gia_ban_le' => obj['basePrice'],
          "ma_dvt" => obj['unit'],
          'ma_lvt' => "TP",
          'tg_tk' =>  true,
          'tk_vt' => "1561",
          'tk_dt' => "51112",
          'tk_gv' => "6321"
        }
        body["ma_dvt"] = dvt if body["ma_dvt"].nil?
        hash << body
      end
      hash
    end
  end
end
