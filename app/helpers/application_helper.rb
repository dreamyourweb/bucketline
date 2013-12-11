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
		if page == "links" && request.path_parameters[:controller] == "links"
			"active"
		elsif page == "dashboard" && request.path_parameters[:controller] == "items"
			"active"
		elsif page == "home" && request.path_parameters[:controller] == "initiatives" && request.path_parameters[:action] == "show"
			"active"
		elsif page == "messages" && request.path_parameters[:controller] == "messages"
			"active"
		elsif page == "calendar" && request.path_parameters[:controller] == "projects"
			"active"
		elsif page == "availability_dashboard" && request.path_parameters[:controller] == "available_dates" && request.path_parameters[:action] == "availability_dashboard"
			"active"
		elsif page == "availability" && request.path_parameters[:controller] == "available_dates" && request.path_parameters[:action] != "availability_dashboard"
			"active"
		elsif page == "profiles" && request.path_parameters[:controller] == "profiles" && request.path_parameters[:action] == "index"
			"active"
		elsif page == "all" && request.path_parameters[:controller] == "profiles" && request.path_parameters[:action] == "all"
			"active"
		elsif page == "profile" && request.path_parameters[:controller] == "profiles" && request.path_parameters[:action] != "index"
			"active"
		else
			"inactive"
		end
	end

  def get_current(page)
    (get_active(page) == "active") ? "current" : ""
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
			:event_height => get_event_height,
			:link_to_day_action => get_link_to_day_action
		}
	end

	def get_event_height
		if request.path_parameters[:controller] == "projects"
			65
		else
			80
		end
	end

	def get_link_to_day_action
		if request.path_parameters[:controller] == "projects" && !(current_user && current_user.initiative_admin(@initiative))
			false
		else
			"new"
		end
	end

	#Override for event_calendar gem
  def day_link(text, date, day_action)
		if request.path_parameters[:controller] == "available_dates"
    	link_to(text, params.merge(:action => day_action, :year => date.year, :month => date.month, :day => date.day), :class => 'ec-day-link fancybox')
		else
    	link_to(text, params.merge(:action => day_action, :year => date.year, :month => date.month, :day => date.day), :class => 'ec-day-link')
		end
  end

	def build_event_text(event)
		text = ""
		if event.success
			text << "<i class='green general foundicon-checkmark right' style='margin-right:2px;'></i>"		
		end
		if current_user && event.providing_user(current_user)
			text << "<i class='red general foundicon-heart right' style='margin-right:2px;'></i>"
		end
		text << build_timetext(event)
		text << "<br><b>#{truncate(event.query, :length => 17)}.</b>"
		if !event.remark.nil?
			text << "<br>#{truncate(event.remark, :length => 17)}"
		end
		text
	end

	def build_timetext(event)
		if event.input_date.nil? #does this project instance still work with dayparts?
			event.daypart.to_sentence
		elsif event.start_at == event.end_at
			"Vanaf " + pretty_time(event.start_at)
		else
			pretty_time(event.start_at) + " - " + pretty_time(event.end_at)
		end
	end

	def pretty_date(date)
		l(date, :format => '%d %B %Y')
	end

	def pretty_time(time)
		time.to_formatted_s(:time)
	end

  def alert(content, type="", no_close=false)
    content_tag "div", class: "alert-box #{type}" do
      (content + (no_close ? "" : content_tag("a", "&times;".html_safe, class: "close"))).html_safe
    end
  end

  def current_initiative
    @initiative = Initiative.where(slug: request.subdomain).first if request.subdomain
  end

  def is_current_page?(path)
    (request.original_url == path) ? "active" : ""
  end

  class BetterFormBuilder < ActionView::Helpers::FormBuilder

    def field_error(field, object=nil)
      if object.nil?
        object = @object
      end
      if object.errors[field].any?
        message = object.errors[field].first
        if message.is_a? Array
          message = message.first
        end
        if message.present?
          "<div class='error'><small class='error'>#{object.errors[field].first}</small></div>".html_safe
        end
      end
    end

  end

end
