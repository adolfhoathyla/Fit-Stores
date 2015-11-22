class AddDeliveryLimitToSales < ActiveRecord::Migration
  def change
  	add_column :sales, :delivery_limit, :string, default: ""
  end
end
