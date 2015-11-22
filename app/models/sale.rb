class Sale < ActiveRecord::Base
	has_many :sale_products
	belongs_to :store
	belongs_to :client
	belongs_to :address
	belongs_to :form_of_payment
end
