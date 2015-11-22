class FixNameColumnTypeOnProduct < ActiveRecord::Migration
  def change
  	rename_column :products, :type, :type_of_suplement
  end
end
