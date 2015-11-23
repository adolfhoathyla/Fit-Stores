class OnSalePercentage < ActiveRecord::Base
	has_many :store_products, dependent: :nullify
end
