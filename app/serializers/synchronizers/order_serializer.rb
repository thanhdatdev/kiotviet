module Synchronizers
  class OrderSerializer < BaseSerializer
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def as_json
      hash = []
      data.each do |obj|
        hash << {
          'so_ct' =>  obj['code'],
          'ngay_ct'=> obj['purchaseDate'],
          'ma_kh' => obj['customerId'],
          't_tt_nt' => obj['total'],
          'ty_le_ck_hd' => obj['discountRatio'],
          'trang_thai' => obj['status'],
          'dien_giai' => obj['description'],
          'tien_ck_hd' => obj['discount'],
          'tien_ck_hd' => obj['discount'],
          'tien_ck_hd' => obj['discount']
          'orderDetails': {
            'id_hang_hoa' => obj['orderDetails']['productId'],
            'ma_vt' => obj['orderDetails']['productCode'],
            'ten_hang_hoa' => obj['orderDetails']['productName'],
            'gia_ban_nt' => obj['orderDetails']['price']
            'sl_xuat' => obj['orderDetails']['quantity'],
            'ty_le_ck' => obj['orderDetails']['discountRatio'],
            'tien_ck_nt' => obj['orderDetails']['discount'],
            'ghi_chu_hang_hoa' => obj['orderDetails']['note']
          },
          'orderDelivery': {
            'ma_van_don' => obj['orderDetails']['deliveryCode'],
            'ten_nguoi_nhan' => obj['orderDetails']['receiver'],
            'sdt_nguoi_nhan' => obj['orderDetails']['contactNumber'],
            'dia_chi_nguoi_nhan' => obj['orderDetails']['address'],
            'khu_vuc_nhan' => obj['orderDetails']['locationId'],
            'phuong_xa' => obj['orderDetails']['locationName'],
          }
        }
      end
      hash
    end

    def to_json
      JSON.dump(as_json)
    end
  end
end
