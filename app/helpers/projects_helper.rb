module ProjectsHelper
  def event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]

			#Build text for calendar event item
			text = ""
			if !event.daypart.nil?
				event.daypart.each do |daytext|
					if daytext != ""
						text << "#{daytext}, "
					end
				end
			end
			text << "#{event.query}"
			if !event.remark.nil?
				text << " - #{event.remark}"
			end
 
     	%(<a class="fancybox" href="/projects/#{event.id.to_s}/items?fancybox=true">#{text}</a>)
    end
  end
end
