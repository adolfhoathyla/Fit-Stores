class StoreProductsController < ApplicationController
  
  # before_action :verify_store_or_store_json_or_admin, only: [:index]
  before_action :verify_store, only: [:new, :create, :edit, :update, :destroy]

  def index
    @on_sale_percentages = OnSalePercentage.where("date_limit < ?", Time.now).destroy_all
    if current_store != nil
  	  @store_products = current_store.store_products
    elsif params[:store_id] != nil
      begin
        @store = Store.find(params[:store_id])
      rescue ActiveRecord::RecordNotFound => e
        @store = nil
      end
      if @store == nil
        respond_to do |format| 
          format.html {redirect_to stores_path, alert: "Não existe loja com esse id!"}
          format.json {render json: @store_products.map {|s| [loja_produto: s.attributes, produto: s.product, loja: s.store]}}
        end
        return
      end
      @store_products = Store.find(params[:store_id]).store_products
    end
    respond_to do |format| 
      format.html
      format.json {render json: @store_products.map {|s| [loja_produto: s.attributes, produto: s.product, loja: s.store]}}
    end
  end

  def new
  	@store_product = StoreProduct.new
  	@products = Product.all.compact
    current_store.store_products.each do |store_product|
      @products.delete(store_product.product)
    end
  end
  
  #post /products
  def create
    #INSERT INTO
    @product = Product.find(Integer(params[:store_product][:id]))
    price = params[:store_product][:price]
    if price.count(',') > 0
      price[","] = "."
    end
    if price.count('R$ ') > 0
      price["R$ "] = ""
    end
    @store_product = current_store.store_products.new(price: price, 
                                                      product_id: params[:store_product][:product_id], 
                                                      store_id: current_store.id)
    @store_product.product = @product
    if @store_product.save

      flavors = params[:flavors][:ids_flavors]

      flavors.each { |id|
        if id != "" && id != "0"
          store_product_flavor = StoreProductFlavor.new
          store_product_flavor.store_product = @store_product
          store_product_flavor.flavor = Flavor.find(id)
          store_product_flavor.save
        end
      }

      redirect_to new_store_product_path, notice: "Criado produto para loja '#{current_store.name}'"
    else
      redirect_to new_store_product_path, alert: "Não Foi Criado produto para loja '#{current_store.name}'"
    end
  end

  def edit
    @store_product = StoreProduct.find(params[:id])
  end

  def update
    @store_product = StoreProduct.find(params[:store_product][:id])
    price = params[:store_product][:price]
    if price.count(',') > 0
      price[","] = "."
    end
    if price.count('R$ ') > 0
      price["R$ "] = ""
    end

    store_product_flavors = StoreProductFlavor.where("store_product_id = ?", @store_product.id)
    store_product_flavors.each do |spf|
      spf.delete
    end

    flavors = params[:flavors][:ids_flavors]

    flavors.each { |id|
      if id != "" && id != "0"
        store_product_flavor = StoreProductFlavor.new
        store_product_flavor.store_product = @store_product
        store_product_flavor.flavor = Flavor.find(id)
        store_product_flavor.save
      end
    }

    if @store_product.update_columns(price: price)
      redirect_to store_products_path, notice: "Editado produto para loja '#{current_store.name}'"
    else
      redirect_to edit_store_product_path, alert: "Não Foi Editado produto para loja '#{current_store.name}'"
    end
  end

  def destroy
    #DELETE FROM products WHERE id = id
    @store_product = StoreProduct.find(params[:id])
    if @store_product.destroy
      redirect_to new_store_product_path, notice: "Excluido produto para loja '#{current_store.name}'"
    else
      redirect_to store_products_path, notice: "Erro ao excluir produto para loja '#{current_store.name}'"
    end
  end

  def verify_store_or_store_json_or_admin
    if current_store == nil and current_store_json == nil and current_admin == nil
      redirect_to new_store_session_path, alert: "Você Não Pode Acessar Essa Página!"
    end
  end

  def verify_store
    if current_admin != nil
      redirect_to products_path, alert: "Você Não Pode Acessar Essa Página!"
    elsif current_store == nil
      redirect_to new_store_session_path, alert: "Você Não Pode Acessar Essa Página!"
    end
  end

  def find_store_products
    @all_store_products = StoreProduct.where("product_id = ?", params[:product_id])

    @store_products = []

    @all_store_products.each do |store_product|
      store = Store.where("id = ? AND active = ?", store_product.store_id, true).first
      if store != nil
        sp = StoreProduct.where("product_id = ? AND store_id = ?", params[:product_id], store.id).first
        @store_products << sp
      end
    end

    respond_to do |format|
      format.json {render json: @store_products}
    end
  end

  def find_store_product_withs_ids
    @on_sale_percentages = OnSalePercentage.where("date_limit < ?", Time.now).destroy_all
    @store_product = StoreProduct.where("product_id = ? AND store_id = ?", params[:product_id], params[:store_id]).first

    respond_to do |format|
      format.json {render json: {store_product: @store_product, on_sale_percentage: @store_product.on_sale_percentage}}
    end
  end

  def find_more_valuable_products
    @on_sale_percentages = OnSalePercentage.where("date_limit < ?", Time.now).destroy_all

    country = params[:country]
    state = params[:state]
    city = params[:city]

    user_latitude = params[:latitude]
    user_longitude = params[:longitude]

    @store_products = Array.new
    all_store_products = Array.new

    if country != nil
      if state != nil
        if city != nil
          all_store_products = StoreProduct.joins(:store => :address).where(addresses:{country:country,state:state,city:city},stores:{active:true}).limit(10)
        else
          all_store_products = StoreProduct.joins(:store => :address).where(addresses:{country:country,state:state},stores:{active:true}).limit(10)
        end
      else
        all_store_products = StoreProduct.joins(:store => :address).where(addresses:{country:country},stores:{active:true}).limit(10)
      end
    end

    all_store_products.each do |store_product|

      store = Store.find(store_product.store_id)
      if store.global_store 

        if @store_products.empty?
          @store_products << store_product
        else
          @store_products.each do |store_product_tmp|
            if store_product_tmp.product_id != store_product.product_id
              @store_products << store_product
            end
          end
        end

      else

        address = Address.find_by_store_id(store_product.store_id)
        distance = Geocoder::Calculations.distance_between([address.latitude,address.longitude], [user_latitude,user_longitude])

        if distance <= 5.0
          if @store_products.empty?
            @store_products << store_product
          else
            @store_products.each do |store_product_tmp|
              if store_product_tmp.product_id != store_product.product_id
                @store_products << store_product
              end
            end
          end
          
        end

      end
    end

    render json: @store_products.map {|sp| [store_product: sp.attributes, product: sp.product.attributes, product_photo: sp.product.photo, store: sp.store.attributes, store_photo: sp.store.photo, address: Address.find_by_store_id(sp.store.id), on_sale_percentage: sp.on_sale_percentage, forms_of_payment_of_store: sp.store.form_of_payment_of_stores.map { |fps| {form_of_payment: FormOfPayment.find(fps.form_of_payment_id)} }]}
  end

end
