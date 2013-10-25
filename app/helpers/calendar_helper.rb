module CalendarHelper

  def calendar_date_events(date, events)
    events = events.where(:start_at.gte => date, :start_at.lte => date+1).all
  end

end
