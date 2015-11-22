require 'net/http'
require 'json'

class Stores::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
  #   super
    #INSERT INTO

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
      redirect_to new_store_registration_path, alert: "Erro ao criar a loja, endereço inválido"
      return
    end
    value_per_km = params[:store][:value_per_km]
    if value_per_km.count(',') > 0
      value_per_km[","] = "."
    end
    if value_per_km.count('R$ ') > 0
      value_per_km["R$ "] = ""
    end

    @store = Store.new(name: params[:store][:name], name_responsible: params[:store][:name_responsible], 
                       cnpj: params[:store][:cnpj], instagram: params[:store][:instagram], 
                       facebook: params[:store][:facebook], site: params[:store][:site], 
                       telephone: params[:store][:telephone], delivery: params[:store][:delivery], 
                       email: params[:store][:email], password: params[:store][:password], 
                       photo: params[:store][:photo], value_per_km: value_per_km)

    @address = Address.new(country: country, state: state, 
                        city: city, district: district, 
                        street: street, number: number, 
                        cep: cep, complement: complement, 
                        full_address: full_address, latitude: latitude, longitude: longitude)

    if @store.save
      @address.store_id = @store.id
      @address.save
      
      ids_forms_of_payment = params[:form_of_payment_of_stores][:ids_forms_of_payment]

      ids_forms_of_payment.each { |id|
        if id != "" and id != "0"
          form_of_payment_of_store = FormOfPaymentOfStore.new
          form_of_payment_of_store.form_of_payment = FormOfPayment.find(id)
          form_of_payment_of_store.store = @store
          form_of_payment_of_store.save
        end
      }

      redirect_to new_store_session_path, notice: "Loja criada com sucesso"
    else
      redirect_to new_store_registration_path, alert: @store.errors.full_messages
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource

  def update_email
    @store = current_store
    if @store.update(email: params[:store][:email])
      redirect_to edit_store_registration_path, notice: "Email editado com sucesso"
    else
      redirect_to edit_store_registration_path, alert: @store.errors.full_messages
    end
  end

  def update_password
    @store = current_store
    current_password = params[:store][:current_password]
    if Store.find(@store.id).valid_password?(current_password)
      if @store.update(email: params[:store][:email])
        redirect_to new_store_session_path, notice: "Senha editada com sucesso, entre com a nova senha"
      else
        redirect_to edit_store_registration_path, alert: @store.errors.full_messages
      end
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
    if @store.update(name: params[:store][:name], name_responsible: params[:store][:name_responsible], 
                       cnpj: params[:store][:cnpj], instagram: params[:store][:instagram], 
                       facebook: params[:store][:facebook], site: params[:store][:site], 
                       telephone: params[:store][:telephone], delivery: params[:store][:delivery], 
                       photo: photo, value_per_km: value_per_km)
      redirect_to edit_store_registration_path, notice: "Informações editadas com sucesso"
    else
      redirect_to edit_store_registration_path, alert: @store.errors.full_messages
    end
  end

  def update_forms_of_payments_of_store
    @store = current_store
    @store.form_of_payment_of_stores.each do |form_of_payment_of_store|
      form_of_payment_of_store.destroy
      ids_forms_of_payment = params[:form_of_payment_of_stores][:ids_forms_of_payment]
    end
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
      redirect_to edit_store_registration_path, alert: @store.errors.full_messages
    end
  end

=begin
  def update
  #   super
    @store = current_store

    photo = params[:store][:photo]
    if photo.blank?
      photo = @store.photo
    end

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
    value_per_km = params[:store][:value_per_km]
    if value_per_km.count(',') > 0
      value_per_km[","] = "."
    end
    if value_per_km.count('R$ ') > 0
      value_per_km["R$ "] = ""
    end

    current_password = params[:store][:current_password]
    if Store.find(@store.id).valid_password?(current_password)
      @store.form_of_payment_of_stores.each do |form_of_payment_of_store|
        form_of_payment_of_store.destroy
      end
      if @store.update(name: params[:store][:name], name_responsible: params[:store][:name_responsible], 
                       cnpj: params[:store][:cnpj], instagram: params[:store][:instagram], 
                       facebook: params[:store][:facebook], site: params[:store][:site], 
                       telephone: params[:store][:telephone], delivery: params[:store][:delivery], 
                       email: params[:store][:email], password: params[:store][:password], 
                       photo: photo, value_per_km: value_per_km)
        
        @address = Address.find_by_store_id(@store.id)
        @address.update(country: country, state: state, 
                        city: city, district: district, 
                        street: street, number: number, 
                        cep: cep, complement: complement, 
                        full_address: full_address, latitude: latitude, longitude: longitude)

        ids_forms_of_payment = params[:form_of_payment_of_stores][:ids_forms_of_payment]

        ids_forms_of_payment.each { |id|
          if id != "" and id != "0"
            form_of_payment_of_store = FormOfPaymentOfStore.new
            form_of_payment_of_store.form_of_payment = FormOfPayment.find(id)
            form_of_payment_of_store.store = @store
            form_of_payment_of_store.save
          end
        }

        redirect_to new_store_session_path, notice: "Loja editada com sucesso, entre com a nova senha"
      else
        redirect_to edit_store_registration_path, alert: "Erro ao editar a loja"
      end
    else
      redirect_to edit_store_registration_path, alert: "Senha antiga tem que ser igual a digitada"
    end
    
  end
=end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
