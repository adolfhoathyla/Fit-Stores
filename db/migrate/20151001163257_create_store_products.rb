class CreateStoreProducts < ActiveRecord::Migration
  def change
    create_table :store_products do |t|
      t.float :price
      t.references :store, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.references :on_sale_percentage, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :store_products, [:store_id, :product_id, :on_sale_percentage_id], :unique => true, :name => 'index_unique_store_products'

  end
end
