class FormOfPaymentOfStore < ActiveRecord::Base
	belongs_to :store
	belongs_to :form_of_payment
end
