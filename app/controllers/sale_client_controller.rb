class SaleClientController < ApplicationController

	before_action :verify_current_client_json, only: [:index, :create, :update]

	def index
		@sales_client = Sale.where(client_id: params[:client_id])
		respond_to do |format| 
  			format.html
  			format.json {render json: @sales_client.map { |sc| [sale: sc.attributes,
  																sale_products: sc.sale_products.map { |sp| [sale_product: sp, product: sp.product, product_photo: sp.product.photo] },   
  																client: current_client_json, 
  																store: Store.find(sc.store_id)] } } 
		end
	end

	def create
		status = "Aguardando Envio Pela Loja"
		@store = Store.find(params[:sale][:store_id])
		@sale_client = current_client_json.sales.new(total_value: params[:sale][:total_value], 
								status: status,
								delivery_value: params[:sale][:delivery_value],
								delivery_limit: params[:sale][:delivery_limit],
								store_id: params[:sale][:store_id],
								address_id: params[:sale][:address_id],
								form_of_payment_id: params[:sale][:form_of_payment_id],
								change: params[:sale][:change])
		if @sale_client.save
			products_store = params[:store_products]
			products_store.each { |product_store|
				sale_product = @sale_client.sale_products.new(price: product_store[:price], 
															  product_id: product_store[:product_id],
															  quantity: product_store[:quantity])
				sale_product.save
			}
			self.send_email_for_store
			respond_to do |format| 
  				format.json {render json: @sale_client}
			end
		end
	end

	def update
		@sale_client = Sale.find(params[:id])
		if @sale_client.update_columns(status: params[:status])
			respond_to do |format| 
  				format.html
  				format.json {render json: [sale_client: @sale_client.attributes]}
			end
		end
	end

	def verify_current_client_json
		if current_client_json == nil
			respond_to do |format| 
  				format.json {render json: { errors: "Not authenticated" },
                					status: :unauthorized }
			end
    	end
	end

	def update_with_status
		@sale_client = Sale.find(params[:sale_id])
		status = params[:sale_status]

		if @sale_client.status == "Aguardando Envio Pela Loja"
			if @sale_client.update(status: status)
				respond_to do |format| 
  					format.json {render json: {sale_client: @sale_client.attributes}}
				end
			else
				respond_to do |format| 
  					format.json {render json: { errors: "Erro ao atualizar status para: #{@sale_client.status}"}}
				end
			end
		else
			respond_to do |format| 
  				format.json {render json: { errors: "Erro ao atualizar status para: #{@sale_client.status}"}}
			end
		end

	end

	def send_email_for_store
		name = @store.name_responsible
    	email = @store.email
    	subject = "Nova Compra Realizada"
		puts "aqui"
    	ContactMailer.alert_sale_store(@store, subject).deliver_now
	end

end
