module ItemsHelper
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
			p "bier en tieten"
			p "event: " + event.id.to_s
			p "question: " + event.question.id.to_s
      %(<a class="fancybox" href="/questions/#{event.question.id.to_s}/items?fancybox=true&highlight=#{event.id.to_s}" title="#{h("Omschrijving: " + event.name + ". Categorie: " + event.question.type + ". Hoort bij vraag: " + event.question.query  + ". Nodig van: " + event.start_at.ctime.to_s + " tot " + event.end_at.ctime.to_s + ". Locatie: " + event.location + ".")}">#{h(event.name)}</a>)
    end
  end
end
