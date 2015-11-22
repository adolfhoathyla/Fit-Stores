class Client < ActiveRecord::Base

  validates :auth_token, uniqueness: true
  before_create :generate_authentication_token!
 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sales
  has_many :addresses

  has_attached_file :photo, styles: { medium: "200x200" }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
  
  def decode_cover_image_data(cover_image_data)
    data = StringIO.new(Base64.decode64(cover_image_data))
    data.class.class_eval { attr_accessor :original_filename, :content_type }
    data.original_filename = "profile.png"
    data.content_type = "image/png"

    self.photo = data
  end

  def valid_password?(password)
    encrypted_password == password || super(password)
  end
end
