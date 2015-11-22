class CreateFormOfPayments < ActiveRecord::Migration
  def change
    create_table :form_of_payments do |t|
      t.string :title, null: false, default: ""

      t.timestamps null: false
    end
  end
end
