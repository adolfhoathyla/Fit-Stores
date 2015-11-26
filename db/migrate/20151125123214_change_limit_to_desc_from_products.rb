class ChangeLimitToDescFromProducts < ActiveRecord::Migration
  def self.up
    change_column :products, :desc, :text, default: nil, null: true
  end

  def self.down
    change_column :products, :desc, :string, default: "", null: false
  end
end
