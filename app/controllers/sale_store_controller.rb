class SaleStoreController < ApplicationController

	before_action :verify_current_store_or_current_store_json, only: [:index, :show, :update_with_status]
	
	def show
		begin
	      @sale = Sale.find(params[:id])
	    rescue ActiveRecord::RecordNotFound => e
	      @sale = nil
	    end
	    if @sale == nil
	    	redirect_to sale_store_index_path(status:"Aguardando Envio Pela Loja", month:Time.now.month, year:Time.now.year), alert: "Essa venda não existe"
	    elsif current_store != @sale.store
	    	redirect_to sale_store_index_path(status:"Aguardando Envio Pela Loja", month:Time.now.month, year:Time.now.year), alert: "Essa venda não é sua"
	    end
	end

	def index
		@status = params[:status]
		@month = params[:month]
		@year = params[:year]
		list_date = Sale.where(store_id: current_store.id, status: @status).order("created_at").select("id, created_at")
		@first_date = list_date.first
		@sales_store = Sale.where("store_id = ? AND status = ? AND MONTH(created_at) = ? AND YEAR(created_at) = ?", current_store.id, @status, @month, @year)
		respond_to do |format| 
  			format.html 
  			format.json {render json: @sales_store.map { |ss| [sale: ss.attributes, 
  																products: ss.sale_products, 
  																client: Client.find(ss.client_id), 
  																store: current_store_json] } }
		end
	end

	def update_with_status
		@sale_store = Sale.find(params[:sale][:id])
		status = ""
		@store = Store.find(@sale_store.store_id)
		if current_store != @store
			redirect_to sale_store_index_path(status:@sale_store.status, month:Time.now.month, year:Time.now.year), alert: "Essa venda não é sua"
			return
		end
		count_confirmed_purchases = @store.count_confirmed_purchases
		if @sale_store.status == "Aguardando Envio Pela Loja"
			status = "Aguardando Loja Confirmar Entrega"
		elsif @sale_store.status == "Aguardando Loja Confirmar Entrega"
			status = "Venda Concluída"
		else
			redirect_to sale_store_index_path(status:"Aguardando Envio Pela Loja", month:Time.now.month, year:Time.now.year), alert: "Esse status não existe"
			return
		end
		count_confirmed_purchases+=1
		if @sale_store.update(status: status)
			@store.update_columns(count_confirmed_purchases: count_confirmed_purchases)
			respond_to do |format| 
  				format.html {redirect_to sale_store_index_path(status: @sale_store.status, month: Time.now.month, year: Time.now.year), notice: "Status atualizado para: #{@sale_store.status}"}
  				format.json {render json: {sale_store: @sale_store.attributes}}
			end
		else
			respond_to do |format| 
  				format.html {redirect_to sale_store_path(id: @sale_store.id), alert: "Erro ao atualizar status para: #{@sale_store.status}"}
  				format.json {render json: { errors: "Erro ao atualizar status para: #{@sale_store.status}"}}
			end
		end
	end

	def cancel_sale_store
		@sale_store = Sale.find(params[:sale][:id])
		@store = Store.find(@sale_store.store_id)
		if current_store != @store
			redirect_to sale_store_index_path(status:@sale_store.status, month:Time.now.month, year:Time.now.year), alert: "Essa venda não é sua"
			return
		end

		if params[:sale][:motivation] == nil
			respond_to do |format| 
  				format.html {redirect_to sale_store_path(id: @sale_store.id), alert: "Para Cancelar Venda Necessita De Um Motivo!"}
  				format.json {render json: { errors: "Para Cancelar Venda Necessita De Um Motivo!"}}
			end
			return
		end

		count_canceled_purchases = @store.count_canceled_purchases
		if @sale_store.status == "Aguardando Loja Confirmar Entrega"
			count_canceled_purchases+=1
		end
		if @sale_store.update(status: "Venda Cancelada Pela Loja")
			@store.update_columns(count_canceled_purchases: count_canceled_purchases)
			respond_to do |format| 
  				format.html {redirect_to sale_store_index_path(status: @sale_store.status, month: Time.now.month, year: Time.now.year), notice: "Status atualizado para: #{@sale_store.status}"}
  				format.json {render json: {sale_store: @sale_store.attributes}}
			end
		else
			respond_to do |format| 
  				format.html {redirect_to sale_store_path(id: @sale_store.id), alert: "Erro ao atualizar status para: #{@sale_store.status}"}
  				format.json {render json: { errors: "Erro ao atualizar status para: #{@sale_store.status}"}}
			end
		end
	end
	
	def verify_current_store_or_current_store_json
		if current_store == nil and current_store_json == nil
			respond_to do |format| 
  				format.html {redirect_to new_store_session_path, alert: "Você Não Pode Acessar Essa Página!"}
  				format.json {render json: { errors: "Not authenticated" },
                					status: :unauthorized }
			end
    	end
	end

end