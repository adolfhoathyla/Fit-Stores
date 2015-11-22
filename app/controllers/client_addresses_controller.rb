class ClientAddressesController < ApplicationController
	
	before_action :authenticate_client_json_with_token!, only: [:index, :create, :update, :destroy]

	def index
		respond_to do |format| 
  			format.html
  			format.json { render json: current_client_json.addresses }
		end
	end

	def create
				
		@address = current_client_json.addresses.new(country: params[:address][:country], 
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

		if @address.save
			respond_to do |format| 
  				format.html
  				format.json {render json: @address }
			end
		else
			respond_to do |format| 
  				format.html
  				format.json {render json: {error: "Erro ao criar"} }
  			end
		end
	end

	def update
		@address = Address.find(params[:id])
				
		if @address.update(country: params[:address][:country], state: params[:address][:state], 
						   city: params[:address][:city], district: params[:address][:district], 
						   street: params[:address][:street], number: params[:address][:number], 
						   cep: params[:address][:cep], complement: params[:address][:complement],
						   full_address: params[:address][:full_address], latitude: params[:address][:latitude],
                        	longitude: params[:address][:longitude])
			respond_to do |format| 
  				format.html
  				format.json {render json: @address }
			end
		else
			respond_to do |format| 
  				format.html
  				format.json {render json: {error: "Erro ao editar"} }
  			end
		end
	end

	def destroy
		@address = Address.find(params[:id])
		if @address.destroy
			render json: { message: "Excluido com sucesso" }
		else
			render json: { error: "Erro ao excluir" }
		end
	end
end