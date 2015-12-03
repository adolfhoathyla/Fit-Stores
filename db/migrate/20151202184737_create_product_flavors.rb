class CreateProductFlavors < ActiveRecord::Migration
  def change
    create_table :product_flavors do |t|
      t.references :product, index: true, foreign_key: true
      t.references :flavor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
