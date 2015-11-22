class AddClientIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :client_id, :integer
    add_index :sales, :client_id
  end
end
