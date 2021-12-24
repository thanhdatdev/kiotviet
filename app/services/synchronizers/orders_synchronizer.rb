module Synchronizers
  class OrdersSynchronizer < BaseSynchronizer

    self.serializer_class_name = "::Synchronizers::OrderSerializer"

    def call
      data = get_data_kiotviet
      extract_data_zenfaco(data)
      extract_data_fascom(data)
    end

    private

    def get_data_kiotviet
      response = HTTParty.get(get_data_kiot_path, query: kiotviet_params, headers: headers_config)
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : { status: response.code }
    end

    private

    def extract_data_zenfaco(response_hash)
      zenfaco = [164023,164026,58560,63321,63594,63322,63299,58618,63312,63908,63597]
      branchZenfaco = []

      response_hash['data'].each do |obj|
        branchZenfaco << obj if zenfaco.include?(obj['branchId'])
      end

      usersZenfaco = users_result_query(branchZenfaco, ENV['ID_APP_ZENFACO'])
      productsZenfaco = products_result_query(branchZenfaco, ENV['ID_APP_ZENFACO'])

      user_path = "/#{ENV['ID_APP_ZENFACO']}/#{ENV['FLEXZEN_API_USERS']}"
      product_path = "/#{ENV['ID_APP_ZENFACO']}/#{ENV['FLEXZEN_API_PRODUCTS']}"
      send_data_users_products(usersZenfaco, productsZenfaco, user_path, product_path)

      orders_data_serializer = data_serializer(branchZenfaco)
      Synchronizers::BaseSynchronizer.call(orders_data_serializer, zenfaco_path)
    end

    def extract_data_fascom(response_hash)
      fascom = [24748,24742,63939,63656]
      branchFascom = []

      response_hash['data'].each do |obj|
        branchFascom << obj if fascom.include?(obj['branchId'])
      end

      usersFascom = users_result_query(branchFascom, ENV['ID_APP_FASCOM'])
      productsZenFascom = products_result_query(branchFascom, ENV['ID_APP_FASCOM'])

      user_path = "/#{ENV['ID_APP_FASCOM']}/#{ENV['FLEXZEN_API_USERS']}"
      product_path = "/#{ENV['ID_APP_FASCOM']}/#{ENV['FLEXZEN_API_PRODUCTS']}"
      send_data_users_products(usersFascom, productsZenFascom, user_path, product_path)

      orders_data_serializer = data_serializer(branchFascom)
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
        user_hash = query_details_flexzen("#{branchPath}/#{ENV['FLEXZEN_API_ORDERS']}", 'ma_kh', ma_kh)
        if user_hash.blank?
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
          product_hash = query_details_flexzen("#{branchPath}/#{ENV['FLEXZEN_API_PRODUCTS']}", 'ma_vt', ma_vt)
          if product_hash.blank?
            pro_hash = query_details_kiotviet("Products", ma_vt)
            productArr << pro_hash
          end
        end
      end
      productArr
    end

    def query_details_flexzen(path, query_name, query)
      response = HTTParty.get(flexzen_url(path), query: {"#{query_name}" => query})
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : {status: response.code}
    end

    def query_details_kiotviet(path, query)
      response = HTTParty.get("#{ENV['KIOTVIET_API_ENDPOINT']}/#{path}/code/#{query}", headers: headers_config)
      response_hash = response.body.present? ? JSON.parse(response.body.to_s) : {status: response.code}
    end

    def flexzen_url(path)
      "#{ENV['FLEXZEN_API_ENDPOINT']}/api/#{path}?access_token=#{ENV['ACCESS_TOKEN_FLEXZEN']}" + "&update=true"
    end

    def kiotviet_params
      {
        'includePayment' => true,
        'includeInvoiceDelivery' => true,
        'SaleChannel' => true
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