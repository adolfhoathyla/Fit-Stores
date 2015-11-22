class CreateSaleProducts < ActiveRecord::Migration
  def change
    create_table :sale_products do |t|
      t.float :price
      t.references :sale, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :sale_products, [:sale_id, :product_id], :unique => true

  end
end
