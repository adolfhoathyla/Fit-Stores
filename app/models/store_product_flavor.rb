class StoreProductFlavor < ActiveRecord::Base
  belongs_to :store_product
  belongs_to :flavor
end
