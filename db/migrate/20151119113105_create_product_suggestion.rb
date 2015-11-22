class CreateProductSuggestion < ActiveRecord::Migration
  def change
    create_table :product_suggestions do |t|
		t.string :name, null: false
      	t.string :brand, null: false
      	t.string :status, null: false
    end
    add_attachment :product_suggestions, :photo
    add_column :product_suggestions, :store_id, :integer
    add_index :product_suggestions, :store_id
  end
end
