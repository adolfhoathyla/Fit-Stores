class FlavorController < ApplicationController
	before_action :verify_admin, only: [:show, :index]
  
  	def new
  		@flavor = Flavor.new
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
