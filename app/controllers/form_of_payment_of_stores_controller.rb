class FormOfPaymentOfStoresController < ApplicationController
  
	before_action :verify_admin, only: [:show, :index]
  
  	def new
  		@form_of_payment_of_store = FormOfPaymentOfStore.new
 	end

  	def create
  	end

	def verify_admin
	    if current_store != nil
		    redirect_to products_path, alert: "Você Não Pode Acessar Essa Página!"
	    elsif current_admin == nil
	      	redirect_to new_admin_session_path, alert: "Você Não Pode Acessar Essa Página!"
	    end
	end
	
end
