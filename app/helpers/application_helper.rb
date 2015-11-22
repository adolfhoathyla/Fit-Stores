module ApplicationHelper
	def resource_name
    	:store
  	end

  	def resource
    	@resource ||= Store.new
  	end

  	def devise_mapping
    	@devise_mapping ||= Devise.mappings[:store]
  	end
end
