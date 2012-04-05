module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

	def get_active(page)
		if page == "dashboard" && request.path_parameters[:controller] == "items"
			"active"
		elsif page == "calendar" && request.path_parameters[:controller] == "projects"
			"active"
		elsif page == "availability" && request.path_parameters[:controller] == "available_dates"
			"active"
		elsif page == "profile" && request.path_parameters[:controller] == "profiles"
			"active"
		else
			"inactive"
		end
	end
end
