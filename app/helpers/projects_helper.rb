module ProjectsHelper
  def event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]
      %(<a class="fancybox" href="/projects/#{event.id.to_s}/items?fancybox=true" title="#{h("Project loopt van: " + event.start_at.ctime.to_s + " tot " + event.end_at.ctime.to_s)}">#{h(event.query)}</a>)
    end
  end
end
