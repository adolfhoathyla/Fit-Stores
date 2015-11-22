class CreateOnSalePercentages < ActiveRecord::Migration
  def change
    create_table :on_sale_percentages do |t|
      t.string :title
      t.float :percentage
      t.datetime :date_limit

      t.timestamps null: false
    end
  end
end
