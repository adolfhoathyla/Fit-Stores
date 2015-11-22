class ProductSuggestionsController < ApplicationController
	before_action :verify_admin, only: [:index, :update_with_status]
	before_action :verify_store, only: [:index_suggestions_of_store, :new, :create, :edit, :update]
	before_action :verify_admin_or_store, only: [:show, :destroy]

	def index_suggestions_of_store
		@products_suggestions = ProductSuggestion.where(store_id: current_store.id)
	end

	def index
		@products_suggestions = ProductSuggestion.all
	end	

	def show
		begin
	      @product_suggestion = ProductSuggestion.find(params[:id])
	    rescue ActiveRecord::RecordNotFound => e
	      @product_suggestion = nil
	    end
	    if @product_suggestion == nil
	    	redirect_to product_suggestions_index_suggestions_of_store_path, alert: "Essa sugestão não existe"
	    elsif current_store != @product_suggestion.store
	    	redirect_to product_suggestions_index_suggestions_of_store_path, alert: "Essa sugestão não é sua"
	    end
	end

	def new
		@product_suggestion = ProductSuggestion.new
	end

	def create
		@product_suggestion = ProductSuggestion.new(name: params[:product_suggestion][:name],
													brand: params[:product_suggestion][:brand],
													photo: params[:product_suggestion][:photo],
													status: "Aguardando Análise Do Adminstrador!")
		@product_suggestion.store = current_store
		if @product_suggestion.save
			redirect_to product_suggestions_index_suggestions_of_store_path, notice: "Sugestão Criada Com Sucesso!"
		else
			redirect_to new_product_suggestion_path, alert: "Erro Ao Criar Sugestão!"
		end
	end

	def edit
		begin
	      @product_suggestion = ProductSuggestion.find(params[:id])
	    rescue ActiveRecord::RecordNotFound => e
	      @product_suggestion = nil
	    end
	    if @product_suggestion == nil
	    	redirect_to product_suggestions_index_suggestions_of_store_path, alert: "Essa sugestão não existe"
	    elsif current_store != @product_suggestion.store
	    	redirect_to product_suggestions_index_suggestions_of_store_path, alert: "Essa sugestão não é sua"
	    end
	end

	def update
		@product_suggestion = ProductSuggestion.find(params[:id])
		if current_store != @product_suggestion.store
	    	redirect_to product_suggestions_index_suggestions_of_store_path, alert: "Essa sugestão não é sua"
	    end
		photo = params[:product_suggestion][:photo]
		if photo.blank?
			photo = @product_suggestion.photo
		end
		if @product_suggestion.update(name: params[:product_suggestion][:name],
									  brand: params[:product_suggestion][:brand],
									  photo: photo)
			redirect_to product_suggestions_index_suggestions_of_store_path, notice: "Status da Sugestão Editada Com Sucesso!"
		else
			redirect_to product_suggestions_index_suggestions_of_store_path, notice: "Erro ao Editar Status da Sugestão!"
		end 
	end

	def update_with_status
		@product_suggestion = ProductSuggestion.find(params[:product_suggestion][:id])
		if @product_suggestion.update(status: params[:product_suggestion][:status])
			redirect_to product_suggestions_path, notice: "Sugestão Editada Com Sucesso!"
		else
			redirect_to product_suggestions_path, notice: "Erro ao Editar Sugestão!"
		end
	end
	
	def destroy
	    #DELETE FROM products WHERE id = id
	    @product_suggestion = ProductSuggestion.find(params[:id])
	    @product_suggestion.destroy
	    if current_store != nil
	    	redirect_to product_suggestions_index_suggestions_of_store_path, notice: "Sugestão Excluída Com Sucesso!"
	    elsif current_admin != nil
	    	redirect_to product_suggestions_path, notice: "Sugestão Excluída Com Sucesso!"
	    end
	end

  	def verify_admin_or_store
    	if current_admin == nil and current_store == nil
      		redirect_to new_store_session_path, alert: "Você Não Pode Acessar Essa Página!"
    	end
  	end

  	def verify_admin
    	if current_store
      		redirect_to products_path, alert: "Você Não Pode Acessar Essa Página!"
    	elsif current_admin == nil
      		redirect_to new_admin_session_path, alert: "Você Não Pode Acessar Essa Página!"
    	end
  	end

  	def verify_store
  		if current_store == nil
  			redirect_to new_store_session_path, alert: "Você Não Pode Acessar Essa Página!"
  		end
  	end
end