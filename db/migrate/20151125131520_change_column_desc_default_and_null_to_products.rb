class ChangeColumnDescDefaultAndNullToProducts < ActiveRecord::Migration
  def change
    change_column_null :products, :desc, false
    change_column_default :products, :desc, ""
  end
end
