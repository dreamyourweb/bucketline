class Profile
  include Mongoid::Document
	include EventCalendar
	has_event_calendar

	embedded_in :user
	has_many :available_dates	

  field :name, :type => String
  field :expertise, :type => String
end
