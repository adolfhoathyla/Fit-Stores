class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.float :total_value
      t.float :delivery_value
      t.string :status

      t.timestamps null: false
    end
  end
end
