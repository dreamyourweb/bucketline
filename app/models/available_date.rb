class AvailableDate
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes
	include EventCalendar
	has_event_calendar

	belongs_to :profile

	attr_accessible :start_at, :end_at

  field :start_at, :type => DateTime
  field :end_at, :type => DateTime

	def self.events_for_date_range(start_d, end_d, find_options = {})
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end

	def calendar_text
		@profile = self.profile
		return @profile.name.to_s + " - " + @profile.expertise.to_s 
	end
end
