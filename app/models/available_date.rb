class AvailableDate
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes
	include EventCalendar
	has_event_calendar

	belongs_to :profile
	before_save :set_start_and_end_date, :build_daypart
	
	# attr_accessible :date, :daypart, :morning, :afternoon, :evening, :night

	field :date, :type => Date
	field :start_at, :type => Date #Depricated
  	field :end_at, :type => Date #Depricated
	field :daypart, :type => Array

	field :morning, :type => Mongoid::Boolean, :default => false
	field :afternoon, :type => Mongoid::Boolean, :default => false
	field :evening, :type => Mongoid::Boolean, :default => false
	field :night, :type => Mongoid::Boolean, :default => false

	def build_daypart
		daypart_array = []
		if self.morning
			daypart_array << "Ochtend"
		end
		if self.afternoon
			daypart_array << "Middag"
		end
		if self.evening
			daypart_array << "Avond"
		end
		if self.night
			daypart_array << "Nacht"
		end
		self.daypart = daypart_array
	end

	def set_start_and_end_date
		self.start_at = self.date
		self.end_at = self.date
	end

	def self.events_for_date_range(start_d, end_d, find_options = {})
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end
end
