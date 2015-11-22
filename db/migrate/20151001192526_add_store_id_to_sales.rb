class AddStoreIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :store_id, :integer
    add_index :sales, :store_id
  end
end
