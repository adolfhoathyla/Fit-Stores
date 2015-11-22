class FormOfPayment < ActiveRecord::Base
	has_many :form_of_payment_of_stores
	has_many :sales
end
