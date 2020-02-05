def customField(object, name)
	unless object.respond_to?(:custom_fields)
		puts "No custom field configured in Redmine for " + object.to_s +  " . Exiting"
		exit
	end 
	fields = object.custom_fields.select { |field| field.name == name}
	if fields.nil?  || fields.first.nil?
		puts "'" + name + "' custom field not configured in Redmine. Exiting"
		exit
	end
	value = fields.first.value;
	if value.nil? 
		puts "'" + name +"' not configured in " + object.class.to_s + ". Exiting"
		exit
	end
	value
end
