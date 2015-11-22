class Store < ActiveRecord::Base

  validates :auth_token, uniqueness: true
  before_create :generate_authentication_token!
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :store_products
  has_many :form_of_payment_of_stores
  has_many :sales
  has_many :product_suggestions
  has_one :address

  has_attached_file :photo, styles: { medium: "200x200" }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates :photo, dimensions: true

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def valid_password?(password)
    encrypted_password == password || super(password)
  end
end
