class AvailableDate
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes
	include EventCalendar
	has_event_calendar

	belongs_to :profile
	before_save :set_start_and_end_date
	
	attr_accessible :date, :daypart

	field :date, :type => Date
	field :start_at, :type => Date
  field :end_at, :type => Date
	field :daypart

	def set_start_and_end_date
		self.start_at = self.date
		self.end_at = self.date
	end

	def self.events_for_date_range(start_d, end_d, find_options = {})
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end
end
