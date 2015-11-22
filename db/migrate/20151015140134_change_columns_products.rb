class ChangeColumnsProducts < ActiveRecord::Migration
  def change
  	change_column_null :products, :type_of_suplement, false
  	change_column_null :products, :desc, false
  	change_column_null :products, :benefits, false
  	change_column_null :products, :contraindication, false
  	change_column_null :products, :name, false
  	change_column_null :products, :brand, false
  	change_column_null :products, :weight, false
  	change_column_default :products, :type_of_suplement, ""
  	change_column_default :products, :desc, ""
  	change_column_default :products, :benefits, ""
  	change_column_default :products, :contraindication, ""
  	change_column_default :products, :name, ""
  	change_column_default :products, :brand, ""
  	change_column_default :products, :weight, ""
  end
end
