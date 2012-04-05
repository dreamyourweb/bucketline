module ProfilesHelper
  def availability_event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]
      %(<a class="fancybox" href="/profiles/#{@profile.id.to_s}/available_dates/#{event.id.to_s}?fancybox=true" title="#{h("Beschikbaarheid")}">#{h(current_user.profile.name - current_user.profile.expertise)}</a>)
    end
  end
end
