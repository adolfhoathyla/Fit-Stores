class SalesController < ApplicationController

	before_action :verify_admin, only: [:show, :index]
  
	def show
		@sale = Sale.find(params[:id])
	end

	def index
		@status = params[:status]
		@month = params[:month]
		@year = params[:year]
		@store_id = params[:store_id]
		list_date = Sale.where(store_id: @store_id, status: @status).order("created_at").select("id, created_at")
		@first_date = list_date.first
		@sales = Sale.where("store_id = ? AND status = ? AND MONTH(created_at) = ? AND YEAR(created_at) = ?", @store_id, @status, @month, @year)
	end

	def verify_admin
	    if current_store != nil
		    redirect_to products_path, alert: "Você Não Pode Acessar Essa Página!"
	    elsif current_admin == nil
	      	redirect_to new_admin_session_path, alert: "Você Não Pode Acessar Essa Página!"
	    end
	end

end