module AvailableDatesHelper
  def availability_event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]
      %(<a class="fancybox" href="#" title="#{h("Van " + event.start_at.to_s + " tot " + event.end_at.to_s)}">#{h("NOG" + " - " + "OPVRAGEN")}</a>)
    end
  end
end
