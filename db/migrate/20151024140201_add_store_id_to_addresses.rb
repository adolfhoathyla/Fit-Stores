class AddStoreIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :store_id, :integer
    add_index :addresses, :store_id
  end
end
