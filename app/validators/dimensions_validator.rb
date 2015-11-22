class DimensionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
 	if not value.queued_for_write[:original].blank?
	    geometry = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
	    proportion = geometry.width/geometry.height
	    record.errors[attribute] << "A Foto Deve Ser Quadrada" unless proportion >= 0.9 and proportion <= 1.1 
	else
		record.errors[attribute] << "A Foto É Obrigatória"
	end 
  end
end