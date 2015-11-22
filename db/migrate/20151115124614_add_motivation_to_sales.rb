class AddMotivationToSales < ActiveRecord::Migration
  def change
  	add_column :sales, :motivation, :string
  end
end
