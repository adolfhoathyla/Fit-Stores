class StoresController < ApplicationController

  #before_action :verify_admin_or_client_json, only: [:show, :index]
  before_action :verify_admin, only: [:update_column_active]
  before_action :authenticate_store_json_with_token!, only: [:update, :destroy]
  before_action :verify_store, only: [:update_email, :update_password, :update_infos_of_stores, :update_forms_of_payments_of_store, :update_address_of_store]
  #respond_to :json

  def show
    @on_sale_percentages = OnSalePercentage.where("date_limit < ?", Time.now)
    @on_sale_percentages.each do |on_sale_percentage|
      on_sale_percentage.destroy
    end
    begin
      @store = Store.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @store = nil
    end
    if @store == nil
      respond_to do |format|
        format.html {redirect_to stores_path, alert: "Não existe loja com esse id!"}
        format.json {render json: {store: @store.store_products.map {|sp| [store_product: sp.attributes, product: sp.product.attributes, product_photo: sp.product.photo, store: @store.attributes, store_photo: @store.photo, on_sale_percentage: sp.on_sale_percentage, address: Address.find_by_store_id(@store.id) ]}, forms_of_payment_of_store: @store.form_of_payment_of_stores.map { |fps| {form_of_payment: FormOfPayment.find(fps.form_of_payment_id)} } }}
      end
      return
    end
    respond_to do |format|
      format.html
      format.json {render json: {store: @store.store_products.map {|sp| [store_product: sp.attributes, product: sp.product.attributes, product_photo: sp.product.photo, store: @store.attributes, store_photo: @store.photo, on_sale_percentage: sp.on_sale_percentage, address: Address.find_by_store_id(@store.id) ]}, forms_of_payment_of_store: @store.form_of_payment_of_stores.map { |fps| {form_of_payment: FormOfPayment.find(fps.form_of_payment_id)} } }}
    end
  end

  def index
    @store = Store.new
    @storesNotActive = Store.where("active = ?", false)
    @storesActive = Store.where("active = ?", true)

  	respond_to do |format|
  		format.html
  		format.json {render json: @storesActive.map {|s| [store: s.attributes, store_photo: s.photo, store_products: s.store_products, address: Address.find_by_store_id(s.id), forms_of_payment_of_store: s.form_of_payment_of_stores.map { |fps| [form_of_payment: FormOfPayment.find(fps.form_of_payment_id)] }]}}
  	end
  end

  def create
  #   super
    #INSERT INTO
    @store = Store.new(name: params[:store][:name], name_responsible: params[:store][:name_responsible], 
                       cnpj: params[:store][:cnpj], instagram: params[:store][:instagram], 
                       facebook: params[:store][:facebook], site: params[:store][:site], 
                       telephone: params[:store][:telephone], delivery: params[:store][:delivery], 
                       reserve: params[:store][:reserve], email: params[:store][:email], 
                       password: params[:store][:password], photo: params[:store][:photo])

    full_address = "#{params[:address][:number]} #{params[:address][:street]} #{params[:address][:district]}, #{params[:address][:city]}, #{params[:address][:state]} #{params[:address][:cep]}, #{params[:address][:country]}"

    @address = Address.new(country: "Brasil", state: params[:address][:state], 
                        city: params[:address][:city], district: params[:address][:district], 
                        street: params[:address][:street], number: params[:address][:number], 
                        cep: params[:address][:cep], complement: params[:address][:complement], 
                        full_address: full_address, latitude: params[:address][:latitude],
                        longitude: params[:address][:longitude])

    if @store.save
      @address.store_id = @store.id
      @address.save
      render json: @store, status: 201
    else
      render json: { errors: @store.errors }, status: 422
    end
  end

  def update
  #   super
    @store = current_store_json
    if @store.update(name: params[:store][:name], name_responsible: params[:store][:name_responsible], 
                      cnpj: params[:store][:cnpj], instagram: params[:store][:instagram], 
                      facebook: params[:store][:facebook], site: params[:store][:site], 
                      telephone: params[:store][:telephone], delivery: params[:store][:delivery], 
                      reserve: params[:store][:reserve], email: params[:store][:email], 
                      password: params[:store][:password])

      @address = Address.find_by_store_id(@store.id)
      full_address = "#{params[:address][:number]} #{params[:address][:street]} #{params[:address][:district]}, #{params[:address][:city]}, #{params[:address][:state]} #{params[:address][:cep]}, Brasil"

      @address.update(country: "Brasil", state: params[:address][:state], 
                      city: params[:address][:city], district: params[:address][:district], 
                      street: params[:address][:street], number: params[:address][:number], 
                      cep: params[:address][:cep], complement: params[:address][:complement], 
                      full_address: full_address, latitude: params[:address][:latitude],
                      longitude: params[:address][:longitude])
      render json: @store, status: 200
    else
      render json: { errors: @store.errors }, status: 422
    end
  end

  def update_column_active
    @store = Store.find(params[:store][:id])
    if @store.active == true 
      if @store.update_columns(active: false)
        @storesNotActive = Store.where("active = ?", false)
        @storesActive = Store.where("active = ?", true)
        redirect_to stores_index_path, notice: "Loja com nome '#{@store.name}' está inativa."
      else
        redirect_to stores_index_path, alert: "Loja com nome: '#{@store.name}' não conseguiu ser ativa"
      end
    elsif @store.active == false
      if @store.update_columns(active: true)
        @storesNotActive = Store.where("active = ?", false)
        @storesActive = Store.where("active = ?", true)
        redirect_to stores_index_path, notice: "Loja com nome: '#{@store.name}' está ativa."
      else
        redirect_to stores_index_path, alert: "Loja com nome: '#{@store.name}' não conseguiu ser inativa"
      end
    end
  end

  def update_email
    @store = current_store
    if @store.update(email: params[:store][:email], photo: @store.photo)
      redirect_to edit_store_registration_path, notice: "Email editado com sucesso"
    else
      redirect_to edit_store_registration_path, alert: "Erro ao editar email da loja"
    end
  end

  def update_password
    @store = current_store
    password_confirmation = params[:store][:password_confirmation]
    password = params[:store][:password]
    if password != password_confirmation
      redirect_to edit_store_registration_path, alert: "As Senhas são diferentes, precisam ser iguais"
      return
    end
    current_password = params[:store][:current_password]
    if Store.find(@store.id).valid_password?(current_password)
      if @store.update(password: password, photo: @store.photo)
        redirect_to new_store_session_path, notice: "Senha editada com sucesso, entre com a nova senha"
      else
        redirect_to edit_store_registration_path, alert: "Erro ao editar senha da loja"
      end
    else
      redirect_to edit_store_registration_path, alert: "Senha antiga está errada"
    end
  end

  def update_infos_of_stores
    @store = current_store

    photo = params[:store][:photo]
    if photo.blank?
      photo = @store.photo
    end
    value_per_km = params[:store][:value_per_km]
    if value_per_km.count(',') > 0
      value_per_km[","] = "."
    end
    if value_per_km.count('R$ ') > 0
      value_per_km["R$ "] = ""
    end
    if params[:store][:delivery] == "0"
      value_per_km = nil
    end
    if @store.update(name: params[:store][:name], name_responsible: params[:store][:name_responsible], 
                       cnpj: params[:store][:cnpj], instagram: params[:store][:instagram], 
                       facebook: params[:store][:facebook], site: params[:store][:site], 
                       telephone: params[:store][:telephone], delivery: params[:store][:delivery], 
                       photo: photo, value_per_km: value_per_km)
      redirect_to edit_store_registration_path, notice: "Informações editadas com sucesso"
    else
      redirect_to edit_store_registration_path, alert: "Erro ao editar informações da loja"
    end
  end

  def update_forms_of_payments_of_store
    @store = current_store
    @store.form_of_payment_of_stores.each do |form_of_payment_of_store|
      form_of_payment_of_store.destroy
    end
    ids_forms_of_payment = params[:form_of_payment_of_stores][:ids_forms_of_payment]
    ids_forms_of_payment.each { |id|
      if id != "" and id != "0"
        form_of_payment_of_store = FormOfPaymentOfStore.new
        form_of_payment_of_store.form_of_payment = FormOfPayment.find(id)
        form_of_payment_of_store.store = @store
        form_of_payment_of_store.save
      end
    }
    redirect_to edit_store_registration_path, notice: "Formas de pagamento editadas com sucesso"
  end

  def update_address_of_store
    @store = current_store
    country = "Brasil"
    state = params[:address][:state]
    city = params[:address][:city]
    district = params[:address][:district].split.map(&:capitalize).join(' ')
    street = params[:address][:street].split.map(&:capitalize).join(' ')
    number = params[:address][:number]
    cep = params[:address][:cep]
    complement = params[:address][:complement].split.map(&:capitalize).join(' ')
    latitude = 0
    longitude = 0

    full_address = "#{number} #{street} #{district}, #{city}, #{state} #{cep}, #{country}"
    full_address_UTF8 = full_address.force_encoding("UTF-8")
    url = URI.parse(URI.encode("http://maps.google.com/maps/api/geocode/json?sensor=false&address=#{full_address_UTF8}"))
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    resultadosJSON = JSON.parse(res.body)
    resultados = resultadosJSON["results"]
    if resultados.count > 0
      resultado = resultados.first
      geometry = resultado["geometry"]
      location = geometry["location"]
      latitude = location["lat"]
      longitude = location["lng"]
    else
      redirect_to edit_store_registration_path, alert: "Erro ao editar a loja, endereço inválido"
      return
    end
    @address = @store.address
    if @address.update(country: country, state: state, 
                        city: city, district: district, 
                        street: street, number: number, 
                        cep: cep, complement: complement, 
                        full_address: full_address, latitude: latitude, longitude: longitude)
      redirect_to edit_store_registration_path, notice: "Endereço editado com sucesso"
    else
      redirect_to edit_store_registration_path, alert: "Erro ao editar endereço da loja"
    end
  end

  def destroy
    current_store_json.destroy
    head 204
  end

  def verify_admin
    if current_store != nil
      redirect_to products_path, alert: "Você Não Pode Acessar Essa Página!"
    elsif current_admin == nil
      redirect_to new_admin_session_path, alert: "Você Não Pode Acessar Essa Página!"
    end
  end

  def verify_store
    if current_store == nil
      redirect_to products_path, alert: "Você Não Pode Acessar Essa Página!"
    end
  end

  def find_stores
    @stores = Store.where("name LIKE ? AND active = ?", "%#{params[:search]}%", true)

    respond_to do |format|
      format.json {render json: { store: @stores.map {|s| [store: s.attributes, store_photo: s.photo, store_products: s.store_products, address: Address.find_by_store_id(s.id),  forms_of_payment_of_store: s.form_of_payment_of_stores.map { |fps| {form_of_payment: FormOfPayment.find(fps.form_of_payment_id)} }]}}}
    end
  end

  def find_nearest_stores
    country = params[:country]
    state = params[:state]
    city = params[:city]

    user_latitude = params[:latitude]
    user_longitude = params[:longitude]

    @stores = Array.new

    all_stores = Array.new

    if country != nil
      if state != nil
        if city != nil
          all_stores = Store.joins(:address).where(addresses:{country:country,state:state,city:city},stores:{active:true})
        else
          all_stores = Store.joins(:address).where(addresses:{country:country,state:state},stores:{active:true})
        end
      else
        all_stores = Store.joins(:address).where(addresses:{country:country},stores:{active:true})
      end
    end

    all_stores.each do |store|

      if store.global_store
        @stores << store

      else 

        address = Address.find_by_store_id(store.id)
        distance = Geocoder::Calculations.distance_between([address.latitude,address.longitude], [user_latitude,user_longitude])

        if distance <= 5.0
          @stores << store
        end

      end
    end

    respond_to do |format|
      format.json {render json: { store: @stores.map {|s| [store: s.attributes, store_photo: s.photo, store_products: s.store_products, address: Address.find_by_store_id(s.id),  forms_of_payment_of_store: s.form_of_payment_of_stores.map { |fps| {form_of_payment: FormOfPayment.find(fps.form_of_payment_id)} }]}}}
    end
  end

end
