class Flavor < ActiveRecord::Base
	has_many :product_flavor, dependent: :nullify
	has_many :store_product_flavor
end
