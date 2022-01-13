module Synchronizers
  class OrderSerializer < BaseSerializer
    attr_reader :data, :branch

    def initialize(data, branch)
      @data = data
      @branch = branch
    end

    def as_json
      hash = []
      data.each do |obj|
        invoiceDelivery = obj['invoiceDelivery'].present?
        default = {
            'so_ct' =>  obj['code'],
            'ngay_ct'=> obj['purchaseDate'],
            'ma_kh' => obj['customerCode'],
            't_tt_nt' => obj['total'],
            'dien_giai' => obj['description'],
            'details' =>
              obj['invoiceDetails']&.map { |invoice|
                {
                  'ma_vt' => invoice['productCode'],
                  'sl_xuat' => invoice['quantity'],
                  'gia_ban_nt' => invoice['price'],
                  'ty_le_ck' => invoice['discountRatio'],
                  'tien_ck_nt' => invoice['discount'],
                  'dien_giai' => invoice['note'],
                  'tien_hang_nt' => invoice['quantity'] * invoice['price'],
                  'tien_nt' => (invoice['quantity'] * invoice['price']) - invoice['discount'],
                  'ma_lvt' => "TP",
                  'tg_tk' =>  true,
                  'tk_vt' => "1561",
                  'tk_dt' => "51112",
                  'tk_gv' => "6321"
                }},
            'ma_van_don' => invoiceDelivery ? obj['invoiceDelivery']['deliveryCode'] : '',
            'ten_nguoi_nhan' => invoiceDelivery ? obj['invoiceDelivery']['receiver'] : '',
            'sdt_nguoi_nhan' => invoiceDelivery ? obj['invoiceDelivery']['contactNumber'] : '',
            'dia_chi_nguoi_nhan' => invoiceDelivery ? obj['invoiceDelivery']['address'] : '',
            'khu_vuc_nhan' => invoiceDelivery ? obj['invoiceDelivery']['locationId'] : '',
            'phuong_xa' => invoiceDelivery ? obj['invoiceDelivery']['locationName'] : '',
            'ma_kho' => obj['branchId'],
            'thu_ho' => invoiceDelivery ? obj['invoiceDelivery']['usingPriceCod'] : false,
            'don_vi_vc' => invoiceDelivery ? obj['invoiceDelivery']['partnerDelivery']['code'] : '',
            'ma_kenh' => 'Kiotviet'
          }
        case branch
        when 'Zenfaco'
          hash << default.merge!(
              'pt_thanh_toan' => '61de7a6b5bc1556ae1e34a24',
              'ten_pt_thanh_toan' => 'COD',
              'nhan_vien_giao_hang' =>  obj['branchId'],
              'trang_thai' => 8
            )
        when 'Fascom'
          hash << default.merge!('trang_thai' => 0)
        end
      end
      hash
    end

    def to_json
      JSON.dump(as_json)
    end
  end
end
