class CreateStoreProductFlavors < ActiveRecord::Migration
  def change
    create_table :store_product_flavors do |t|
      t.references :store_product, index: true, foreign_key: true
      t.references :flavor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
