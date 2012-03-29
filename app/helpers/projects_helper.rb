module ProjectsHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end

  # custom options for this calendar
  def event_calendar_options
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>",
			:first_day_of_week => @first_day_of_week
    }
  end

  def event_calendar
    calendar event_calendar_options do |args|
      event = args[:event]
      %(<a class="fancybox" href="/projects/#{event.id.to_s}/items?fancybox=true" title="#{h("Project loopt van: " + event.start_at.ctime.to_s + " tot " + event.end_at.ctime.to_s)}">#{h(event.query)}</a>)
    end
  end
end
