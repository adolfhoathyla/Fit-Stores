class ClientsSessionsController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token

	def new
		@client = Client.new
	end

	def create
	    @client_password = params[:client][:password]
	    @client_email = params[:client][:email]
	    @client = @client_email.present? && Client.find_by(email: @client_email)

	    if @client.valid_password? @client_password
	      	sign_in @client, store: false
	      	@client.generate_authentication_token!
	      	@client.save
	      	puts @client.birth_date
	  		render json: [client: @client.attributes, client_photo: @client.photo, client_addresses: @client.addresses, client_sales: @client.sales]
	  	  
	    else
	      	render json: { errors: "Invalid email or password" }, status: 422
	    end
  	end

	def destroy
	  	@client = Client.find(params[:id])
	    @client.generate_authentication_token!
	    @client.save
	    head 204
	end

end