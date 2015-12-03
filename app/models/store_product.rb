class StoreProduct < ActiveRecord::Base
  belongs_to :store
  belongs_to :product
  belongs_to :on_sale_percentage
  has_many :store_product_flavor
end
