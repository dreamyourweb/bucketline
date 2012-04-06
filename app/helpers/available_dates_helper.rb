module AvailableDatesHelper
  def availability_event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]
      %(<a class="fancybox" href=#{profile_available_date_path(event.profile, event)}?fancybox=true">#{h(event.calendar_text)}</a>)
    end
  end
end
