class ClientsController < ApplicationController

	before_action :verify_admin, only: [:index]
	before_action :verify_admin_or_client_json, only: [:show]
	before_action :authenticate_client_json_with_token!, only: [:update, :destroy]
	respond_to :json

	def show
		@client = Client.find(params[:id])
		respond_to do |format|
			format.html
			# format.json {render json: @client.map {|c| [client: c.attributes, client_photo: c.photo, client_addresses: c.addresses, client_sales: c.sales]}}
      format.json {render json: @client}
		end
	end

	def index
		@clients = Client.all

		respond_to do |format|
			format.html
			format.json {render json: @clients.map {|c| [client: c.attributes, client_addresses: c.addresses, client_sales: c.sales]}}
		end
	end

	def create
	#   super
    #INSERT INTO
    @client = Client.new(name: params[:client][:name], telephone: params[:client][:telephone], 
    					           birth_date: params[:client][:birth_date], cpf: params[:client][:cpf], 
                         email: params[:client][:email], password: params[:client][:password])
    @client.decode_cover_image_data(params[:client][:photo])

    if @client.save
      address = @client.addresses.new(country: params[:address][:country], 
                                      state: params[:address][:state],
                                      city: params[:address][:city],  
                                      district: params[:address][:district], 
                                      street: params[:address][:street],
                                      number: params[:address][:number], 
                                      cep: params[:address][:cep],
                                      complement: params[:address][:complement],
                                      full_address: params[:address][:full_address],
                                      latitude: params[:address][:latitude],
                                      longitude: params[:address][:longitude])
      address.save
      render json: @client, status: 201
    else
      render json: { errors: @client.errors }, status: 422
    end
  end

  def update
  #   super
    @client = current_client_json
    current_password = params[:client][:current_password]
    if Client.find(@client.id).valid_password?(current_password)
      @client.decode_cover_image_data(params[:client][:photo])
      if @client.update(name: params[:client][:name], telephone: params[:client][:telephone], 
    					          birth_date: params[:client][:birth_date], email: params[:client][:email], 
                        cpf: params[:client][:cpf], password: params[:client][:password])
        render json: [client: @client.attributes, client_photo: @client.photo], status: 200
      else
        render json: { errors: @client.errors }, status: 422
	    end
    else
      render json: { errors: "Senha antiga é diferente" }, status: 422
    end
  end

  def destroy
    current_client_json.destroy
    head 204
  end

  def verify_admin
    if current_store != nil
      redirect_to products_path
    elsif current_admin == nil
      redirect_to new_admin_session_path
    end
  end

  def verify_admin_or_client_json
    if current_store != nil
      redirect_to products_path
    elsif current_admin == nil and current_client_json == nil
      redirect_to new_admin_session_path
    end
  end
end