class AddChangeToSales < ActiveRecord::Migration
  def change
  	add_column :sales, :change, :float, default: 0
  end
end
