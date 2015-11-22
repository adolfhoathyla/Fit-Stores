class ProductSuggestion < ActiveRecord::Base
	belongs_to :store

	validates :name, presence: {message: "O Nome da Sugestão do Produto É Obrigatório"}
	validates :brand, presence: {message: "A Marca da Sugestão do Produto É Obrigatório"}
	validates :photo, presence: {message: "A Foto da Sugestão do Produto É Obrigatório"}
	validates :status, presence: {message: "O Status da Sugestão do Produto É Obrigatório"}
  	
	has_attached_file :photo, styles: {medium: "200x200"}
	validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
end