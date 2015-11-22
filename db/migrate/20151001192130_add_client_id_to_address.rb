class AddClientIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :client_id, :integer
    add_index :addresses, :client_id
  end
end
