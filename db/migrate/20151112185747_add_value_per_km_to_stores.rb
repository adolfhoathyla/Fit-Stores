class AddValuePerKmToStores < ActiveRecord::Migration
  def change
  	add_column :stores, :value_per_km, :float
  end
end
