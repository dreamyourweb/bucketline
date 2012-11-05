module ProjectsHelper
  def event_calendar
    calendar event_calendar_options do |args|
      event = args[:event] 
     	%(<a class="fancybox" href="/projects/#{event.id.to_s}/items?fancybox=true">#{build_event_text(event)}</a>)
    end
  end
end
