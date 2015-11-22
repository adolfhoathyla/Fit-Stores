class AddAddressIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :address_id, :integer
    add_index :sales, :address_id
  end
end
