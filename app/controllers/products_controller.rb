class ProductsController < ApplicationController

  before_action :verify_store_or_store_json_or_admin_or_client_json, only: [:index, :show]
  before_action :verify_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
  	@products = Product.all

  	respond_to do |format| 
  		format.html
  		format.json {render json: @products.map {|p| [products: p.attributes, product_photo: p.photo.url]}}
  	end
  end

  def show
    begin
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @product = nil
    end
    respond_to do |format|
      if @product != nil
        format.html
        format.json {render json: [@product.attributes, @product.photo.url]}
      else
        format.html {redirect_to products_path, alert: "Não existe produto com esse id!"}
        format.json {render json: [@product.attributes, @product.photo.url]}
      end
    end
  end

  #get /products/new
  def new
    @product = Product.new
  end

  #get /products/:id/edit
  def edit
    @product = Product.find(params[:id])
  end

  #post /products
  def create
    #INSERT INTO
    photo = params[:product][:photo]
    @product = Product.new(name: params[:product][:name], type_of_suplement: params[:product][:type_of_suplement], 
                           benefits: params[:product][:benefits], 
                           contraindication: params[:product][:contraindication], brand: params[:product][:brand], 
                           weight: params[:product][:weight], type_of_state: params[:product][:type_of_state], 
                           desc: params[:product][:desc], photo: photo)
    
    if @product.save
      redirect_to products_path, notice: "Produto com nome '#{@product.name}' criado com sucesso"
    else
      redirect_to new_product_path, alert: @product.errors.full_messages
    end
    
  end

  def destroy
    #DELETE FROM products WHERE id = id
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
    
  end

  #put /products/:id
  def update
    # UPDATE
    @product = Product.find(params[:id])

    photo = params[:product][:photo]
    if photo.blank?
      photo = @product.photo
    end

    if @product.update(name: params[:product][:name], type_of_suplement: params[:product][:type_of_suplement], 
                       benefits: params[:product][:benefits], 
                       contraindication: params[:product][:contraindication], brand: params[:product][:brand], 
                       weight: params[:product][:weight], type_of_state: params[:product][:type_of_state], 
                       desc: params[:product][:desc], photo: photo)
      redirect_to products_path, notice: "Produto com nome '#{@product.name}' editado com sucesso"
    else
      redirect_to edit_product_path, alert: @product.errors.full_messages
    end
  end

  def verify_store_or_store_json_or_admin_or_client_json
    if current_admin == nil and current_store == nil and current_store_json == nil and current_client_json == nil
      redirect_to new_store_session_path
    end
  end

  def verify_admin
    if current_store
      redirect_to products_path
    elsif current_admin == nil
      redirect_to new_admin_session_path, alert: "Você Não Pode Acessar Essa Página!"
    end
  end

  def find_products
    @products = Product.where("name LIKE ?", "%#{params[:search]}%")

    respond_to do |format|
      format.json {render json: @products.map {|p| [products: p.attributes, product_photo: p.photo.url]}}
    end
  end

  

end
