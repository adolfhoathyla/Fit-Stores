class Product < ActiveRecord::Base
	has_many :sale_products
	has_many :store_products, dependent: :destroy

	validates :type_of_suplement, presence: {message: "O Tipo do Produto É Obrigatório"}
	validates :desc, presence: {message: "A Descrição do Produto É Obrigatório"}
	validates :benefits, presence: {message: "Os Benefícios do Produto São Obrigatórios"}
	validates :contraindication, presence: {message: "A Contraindicação do Produto É Obrigatório"}
	validates :name, presence: {message: "O Nome do Produto É Obrigatório"}
	validates :brand, presence: {message: "A Marca do Produto É Obrigatório"}
	validates :weight, presence: {message: "O Peso do Produto É Obrigatório"}
  	validates :photo, dimensions: true
	
	has_attached_file :photo, styles: {medium: "200x200"}
	validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
end
