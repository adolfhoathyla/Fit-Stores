class OnSalePercentagesController < ApplicationController
	
	before_action :verify_store_or_store_json, only: [:new, :create, :edit, :update, :destroy]
	#before_action :verify_client_json, only: [:index]

	def index
    	@on_sale_percentages = OnSalePercentage.where("date_limit < ?", Time.now).destroy_all
		@on_sale_percentages = OnSalePercentage.where("date_limit > ?", Time.now)
		render json: @on_sale_percentages.map { |osp| [ on_sale_percentage: osp, store_products: osp.store_products.map { |sp| [store_product: sp, product: sp.product, product_photo: sp.product.photo, store: sp.store, store_photo: sp.store.photo, address: Address.find_by_store_id(sp.store.id), on_sale_percentage: sp.on_sale_percentage, forms_of_payment_of_store: sp.store.form_of_payment_of_stores.map { |fps| {form_of_payment: FormOfPayment.find(fps.form_of_payment_id)} } ] } ] }
	end

	def new
		begin
	        @store_product = StoreProduct.find(params[:store_product_id])
	    rescue ActiveRecord::RecordNotFound => e
	        @store_product = nil
	    end
	    if @store_product == nil 
	    	redirect_to store_products_path, alert: "Não existe nenhum produto com esse id na loja"
	    	return
	    elsif @store_product.store != current_store
	    	redirect_to store_products_path, alert: "Esse produto nao é seu"
	    	return
	    end
	    numeroDePromocoesDaLoja = StoreProduct.joins(:store).where(stores:{id:current_store.id}).where("on_sale_percentage_id is not null").count
	    if numeroDePromocoesDaLoja >= 5
	    	redirect_to store_products_path, alert: "Você excedeu o limite de promoções, por favor, exclua alguma para adicionar outra."
	    	return
	    end
		@on_sale_percentage = OnSalePercentage.new
	end

	def create
		date_limit = params[:on_sale_percentage][:date_limit]
		hour_limit = params[:hour_limit]
		date = "#{date_limit} #{hour_limit}"
		if date.to_time < Time.now
			redirect_to new_on_sale_percentage_path(store_product_id: params[:on_sale_percentage][:store_product_id]), alert: "Erro ao Criar a promoção, Data Já Passou!"
			return
		end

		@on_sale_percentage = OnSalePercentage.new(percentage: params[:on_sale_percentage][:percentage],
												   title: params[:on_sale_percentage][:title],
												   date_limit: date)
		@store_product = StoreProduct.find(params[:on_sale_percentage][:store_product_id])
		if @on_sale_percentage.save
			@store_product.on_sale_percentage = @on_sale_percentage
			@store_product.update(on_sale_percentage_id: @on_sale_percentage.id)
			redirect_to store_products_path, notice: "Criado promoção do produto"
		else
			redirect_to new_on_sale_percentage_path(store_product_id: params[:on_sale_percentage][:store_product_id]), alert: "Erro ao Criar a promoção!"
		end
	end

	def edit
		begin
	        @store_product = StoreProduct.find(params[:id])
	    rescue ActiveRecord::RecordNotFound => e
	        @store_product = nil
	    end
	    if @store_product == nil 
	    	redirect_to store_products_path, alert: "Não existe nenhum produto com esse id na loja"
	    	return
	    elsif @store_product.store != current_store
	    	redirect_to store_products_path, alert: "Esse produto nao é seu"
	    	return
	    end
		@on_sale_percentage = @store_product.on_sale_percentage
	end

	def update
		@store_product = StoreProduct.find(params[:on_sale_percentage][:store_product_id])
		if @store_product.store != current_store
	    	redirect_to store_products_path, alert: "Esse produto nao é seu"
	    	return
	    end
		date_limit = params[:on_sale_percentage][:date_limit]
		hour_limit = params[:hour_limit]
		date = "#{date_limit} #{hour_limit}"
		if date.to_time < Time.now
			redirect_to edit_on_sale_percentage_path(@store_product), alert: "Erro ao Editar a promoção, Data Já Passou!"
			return
		end

		@on_sale_percentage = OnSalePercentage.find(params[:id])
		if @on_sale_percentage.update(percentage: params[:on_sale_percentage][:percentage],
								      title: params[:on_sale_percentage][:title],
								      date_limit: date)
			redirect_to store_products_path, notice: "Editado promoção do produto"
		else
			redirect_to edit_on_sale_percentage_path(@store_product), alert: "Erro ao Editar a promoção!"
		end
	end

	def destroy
		@on_sale_percentage = OnSalePercentage.find(params[:id])
		@on_sale_percentage.destroy
		redirect_to store_products_path, notice: "Promoção Excluída Com Sucesso!"
	end

	def verify_store_or_store_json
	    if current_store == nil and current_store_json == nil
	    	redirect_to new_store_session_path, alert: "Você Não Pode Acessar Essa Página!"
   		end
  	end

  	def verify_client_json
	    if current_client_json == nil
	    	render json: { errors: "Not Authenticated" }, status: 422
   		end
  	end
end
