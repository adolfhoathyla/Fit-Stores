class AddFormOfPaymentIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :form_of_payment_id, :integer
    add_index :sales, :form_of_payment_id
  end
end
