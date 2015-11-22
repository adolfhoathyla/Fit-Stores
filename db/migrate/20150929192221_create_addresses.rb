class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :state
      t.string :city
      t.string :district
      t.string :street
      t.string :number
      t.string :cep
      t.string :full_address

      t.timestamps null: false
    end
  end
end
