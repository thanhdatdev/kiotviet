module Synchronizers
  class OrdersSynchronizer < BaseSynchronizer

    self.serializer_class_name = "::Synchronizers::OrderSerializer"

    def call
      branchZenfaco = []
      # zenfaco = [164023,164026,58560,63321,63594,63322,63299,58618,63312,63908,63597]
      inventoriesReject = [24745]
      fascom = [24748,24742,63939,63656]
      branchFascom = []
      statusValueReject = [2, 5]

      response_hash = get_data_kiotviet['data']
      ordersZenfaco = HTTParty.get(flexzen_url(zenfaco_path), query: { 'limit': 100 }, timeout: 1000000)&.map { |order| order['so_ct'] }
      ordersFascom = HTTParty.get(flexzen_url(fascom_path), query: { 'limit': 100 }, timeout: 1000000)&.map { |order| order['so_ct'] }
      orders = ordersZenfaco.union(ordersFascom)

      response_hash = response_hash.filter { |data| !orders.include?(data['code'])}
      response_hash.delete_if { |data| statusValueReject.include?(data['status']) || inventoriesReject.include?(data['branchId'])}
      response_hash.each do |obj|
        fascom.include?(obj['branchId']) ? branchFascom << obj : branchZenfaco << obj
      end

      # updateAll
      extract_data_zenfaco(branchZenfaco)
      extract_data_fascom(branchFascom)
    end

    private

    def updateAll
      hash = []
      response = HTTParty.get(flexzen_url("#{ENV['ID_APP_ZENFACO']}/so1"))
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : {status: response.code}
      response_hash = response_hash.filter {|res| res['ten_trang_thai'] == "Chờ xác nhận"}
      response_hash.each do |res|
        hash << res.merge!(
          'pt_thanh_toan' => '61de7a6b5bc1556ae1e34a24',
          'ten_pt_thanh_toan' => 'COD',
          'nhan_vien_giao_hang' =>  res['ma_kho'],
          'trang_thai' => 8
        )
      end
      Synchronizers::BaseSynchronizer.call(hash, zenfaco_path)
    end

    def get_data_kiotviet
      response = HTTParty.get(get_data_kiot_path, query: kiotviet_params, headers: headers_config)
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : { status: response.code }
    end

    private

    def extract_data_zenfaco(branchZenfaco)
      usersZenfaco = users_result_query(branchZenfaco, ENV['ID_APP_ZENFACO'])
      productsZenfaco = products_result_query(branchZenfaco, ENV['ID_APP_ZENFACO'])

      user_path = "/#{ENV['ID_APP_ZENFACO']}/#{ENV['FLEXZEN_API_USERS']}"
      product_path = "/#{ENV['ID_APP_ZENFACO']}/#{ENV['FLEXZEN_API_PRODUCTS']}"
      send_data_users_products(usersZenfaco, productsZenfaco, user_path, product_path)

      orders_data_serializer = data_serializer(branchZenfaco, 'Zenfaco')
      Synchronizers::BaseSynchronizer.call(orders_data_serializer, zenfaco_path)
    end

    def extract_data_fascom(branchFascom)
      usersFascom = users_result_query(branchFascom, ENV['ID_APP_FASCOM'])
      productsFascom = products_result_query(branchFascom, ENV['ID_APP_FASCOM'])

      user_path = "/#{ENV['ID_APP_FASCOM']}/#{ENV['FLEXZEN_API_USERS']}"
      product_path = "/#{ENV['ID_APP_FASCOM']}/#{ENV['FLEXZEN_API_PRODUCTS']}"
      send_data_users_products(usersFascom, productsFascom, user_path, product_path)

      orders_data_serializer = data_serializer(branchFascom, 'Fascom')
      Synchronizers::BaseSynchronizer.call(orders_data_serializer, fascom_path)
    end

    def send_data_users_products(users ,products, user_path, product_path)
      users_hash = ::Synchronizers::UserSerializer.new(users).as_json
      Synchronizers::Flexzen.api_request(:post, user_path + '/import/json', body: users_hash)

      products_hash = ::Synchronizers::ProductSerializer.new(products).as_json
      Synchronizers::Flexzen.api_request(:post, product_path + '/import/json', body: products_hash)
    end

    def users_result_query(branch, branchPath)
      userArr = []
      branch.each do |branchObj|
        ma_kh = branchObj['customerCode'].to_s
        unless ma_kh.ascii_only?
          userArr << {
            'code' => branchObj['customerCode'].upcase,
            'name' => branchObj['customerName']
          }
        else
          customer_hash = query_details_kiotviet("customers", ma_kh)
          next if customer_hash['code'].blank?
          userArr << customer_hash
        end
      end
      userArr
    end

    def products_result_query(branch, branchPath)
      productArr = []
      branch.each do |branchObj|
        branchObj['invoiceDetails'].each do |invoice|
          ma_vt = invoice['productCode'].to_s
          unless ma_vt.ascii_only?
            productArr << {
              'code' => invoice['productCode'].upcase,
              'fullName' => invoice['productName'],
              'unit' =>  "Cái",
            }
          else
            pro_hash = query_details_kiotviet("Products", ma_vt)
            next if productArr.include?(pro_hash['productCode'])
            productArr << pro_hash
          end
        end
      end
      productArr
    end

    # def query_details_flexzen(path, query_name, query)
    #   response = HTTParty.get(flexzen_url(path), query: {"#{query_name}" => query})
    #   response_hash = response.body.present? ? JSON.parse(response.body.to_s) : {status: response.code}
    # end

    def query_details_kiotviet(path, query)
      response = HTTParty.get("#{ENV['KIOTVIET_API_ENDPOINT']}/#{path}/code/#{query}", headers: headers_config)
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : {status: response.code}
    end

    def flexzen_url(path)
      "#{ENV['FLEXZEN_API_ENDPOINT']}/api/#{path}?access_token=#{ENV['ACCESS_TOKEN_FLEXZEN']}" + "&update=true&ass=1"
    end

    def kiotviet_params
      {
        'includeInvoiceDelivery' => true,
        'pageSize' => 100
        # 'fromPurchaseDate' => DateTime.new(2022,1,8,0,0,0, '+07:00'),
        # 'toPurchaseDate' => DateTime.new(2022,1,9,0,0,0, '+07:00')
      }
    end

    def get_data_kiot_path
      "#{ENV['KIOTVIET_API_ENDPOINT']}/invoices"
    end

    def zenfaco_path
      "/#{ENV['ID_APP_ZENFACO']}/#{ENV['FLEXZEN_API_ORDERS']}"
    end

    def fascom_path
      "/#{ENV['ID_APP_FASCOM']}/#{ENV['FLEXZEN_API_ORDERS']}"
    end
  end
end
