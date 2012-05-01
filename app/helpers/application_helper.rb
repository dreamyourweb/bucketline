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
		elsif page == "home" && request.path_parameters[:controller] == "home"
			"active"
		elsif page == "calendar" && request.path_parameters[:controller] == "projects"
			"active"
		elsif page == "availability_dashboard" && request.path_parameters[:controller] == "available_dates" && request.path_parameters[:action] == "availability_dashboard"
			"active"
		elsif page == "availability" && request.path_parameters[:controller] == "available_dates" && request.path_parameters[:action] != "availability_dashboard"
			"active"
		elsif page == "profile" && request.path_parameters[:controller] == "profiles"
			"active"
		else
			"inactive"
		end
	end

  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end

  def event_calendar_options
    defaults = { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>",
			:first_day_of_week => @first_day_of_week,
			:event_height => 75,
			:link_to_day_action => "new"
		}
	end
end
