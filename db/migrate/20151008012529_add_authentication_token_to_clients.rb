class AddAuthenticationTokenToClients < ActiveRecord::Migration
  def change
    add_column :clients, :auth_token, :string, default: ""
    add_index :clients, :auth_token, unique: true
  end
end
