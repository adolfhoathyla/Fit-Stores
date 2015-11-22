module Authenticable

  # Devise methods overwrites
  def current_store_json
  	@current_store_json ||= Store.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_store_json_with_token!
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless store_json_signed_in?
  end

  def store_json_signed_in?
    current_store_json.present?
  end

  def current_client_json
    @current_client_json ||= Client.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_client_json_with_token!
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless client_json_signed_in?
  end

  def client_json_signed_in?
    current_client_json.present?
  end
end