class Address < ActiveRecord::Base
	belongs_to :client
	belongs_to :store
	has_one :sale
	
	validates :country, presence: {message: "O País É Obrigatório"}
	validates :state, presence: {message: "O Estado É Obrigatório"}
	validates :city, presence: {message: "A Cidade É Obrigatória"}
	validates :district, presence: {message: "O Bairro É Obrigatório"}
	validates :street, presence: {message: "A Rua É Obrigatória"}
	validates :number, presence: {message: "O Número É Obrigatório"}
	
end
