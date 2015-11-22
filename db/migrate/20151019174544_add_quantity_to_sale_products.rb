class AddQuantityToSaleProducts < ActiveRecord::Migration
  def change
  	add_column :sale_products, :quantity, :integer, default: 0
  end
end
