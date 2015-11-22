class CreateFormOfPaymentOfStores < ActiveRecord::Migration
  def change
    create_table :form_of_payment_of_stores do |t|

      t.references :form_of_payment, index: true, foreign_key: true
   	  t.references :store, index: true, foreign_key: true	
      t.timestamps null: false
    end
  end
end
