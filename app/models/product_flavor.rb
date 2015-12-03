class ProductFlavor < ActiveRecord::Base
  belongs_to :product
  belongs_to :flavor
end
