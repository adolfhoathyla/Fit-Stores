class AddTypeOfStateToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :type_of_state, :string
  end
end
