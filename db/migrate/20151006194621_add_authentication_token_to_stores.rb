class AddAuthenticationTokenToStores < ActiveRecord::Migration
  def change
    add_column :stores, :auth_token, :string, default: ""
    add_index :stores, :auth_token, unique: true
  end
end
