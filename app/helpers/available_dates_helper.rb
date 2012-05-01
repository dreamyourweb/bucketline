module AvailableDatesHelper
  def availability_event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]

			#Build text for calendar event item
			text = ""
			if !event.daypart.nil?
				event.daypart.each do |daytext|
					if daytext != ""
						text << "#{daytext}<br>"
					end
				end
			end
			html = %(<a class="fancybox" href=#{edit_profile_available_date_path(@profile, event)}?fancybox=true&year=#{event.date.year.to_s}&month=#{event.date.month.to_s}&day=#{event.date.day.to_s}">#{text}</a>)
    end
  end
end
