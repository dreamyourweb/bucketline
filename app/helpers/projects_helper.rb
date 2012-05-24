module ProjectsHelper
  def event_calendar
    calendar event_calendar_options do |args|
      event = args[:event] 
     	%(<a class="fancybox #{get_project_color_class(event)}" href="/projects/#{event.id.to_s}/items?fancybox=true">#{build_event_text(event)}</a>)
    end
  end

	def get_project_color_class(project)
		class_name = ""
		if project.success
			class_name = "success-calendar"
		elsif user_signed_in?
			project.items.each do |item|
				if item.profile_ids.include?(current_user.profile.id)
					class_name = "providing-calendar"
				end
			end
		end
		class_name
	end	
end
