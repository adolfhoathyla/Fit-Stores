class StoresSessionsController < ApplicationController
	respond_to :json
	skip_before_filter  :verify_authenticity_token

	def new
		@store = Store.new
	end

	def create
	    @store_password = params[:store][:password]
	    @store_email = params[:store][:email]
	    @store = @store_email.present? && Store.find_by(email: @store_email)

	    if @store.valid_password? @store_password
	      	sign_in @store, store: false
	      	@store.generate_authentication_token!
	      	@store.save
	      
	  		render json: @store, status: 200
	  	  
	    else
	      	render json: { errors: "Invalid email or password" }, status: 422
	    end
  	end

	def destroy
	  	@store = Store.find_by(auth_token: params[:id])
	    @store.generate_authentication_token!
	    @store.save
	    head 204
	end

end