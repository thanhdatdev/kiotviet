class CreateKiotVietOAuth2 < ActiveRecord::Migration[7.0]
  def change
    create_table :kiot_viet_o_auth2s do |t|
      t.string     :ip_address
      t.string     :client_id
      t.string     :client_serect
      t.text       :access_token
      t.string     :token_type
      t.timestamps
    end
  end
end
