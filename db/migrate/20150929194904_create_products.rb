class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :type
      t.string :desc
      t.string :benefits
      t.string :contraindication
      t.string :name
      t.string :brand
      t.string :weight

      t.timestamps null: false
    end

    add_attachment :products, :photo
    
  end
end
