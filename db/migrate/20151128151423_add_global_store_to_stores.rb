class AddGlobalStoreToStores < ActiveRecord::Migration
  def change
    add_column :stores, :global_store, :boolean
  end
end
