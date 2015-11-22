class SaleProductsController < ApplicationController
	
	before_action :verify_current_client_json_or_current_store_json, only: [:index]

	def index
		@sale = Sale.find(params[:sale_id])
		respond_to do |format| 
  			format.html
  			format.json {render json: @sale.sale_products.map { |sp| [sale_product: sp.attributes, 
  																	  product: Product.find(sp.product_id)]}}
		end
	end
	
	def verify_current_client_json_or_current_store_json
		if current_client_json == nil and current_store_json == nil
			respond_to do |format| 
  				format.html {redirect_to new_store_session_path, alert: "Você Não Pode Acessar Essa Página!"}
  				format.json {render json: { errors: "Not authenticated" },
                					status: :unauthorized }
			end
    	end
	end

end