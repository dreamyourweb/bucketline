class Project
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes
	include EventCalendar
	has_event_calendar
	
	has_many :items, :autosave => true, :dependent => :delete
	
	accepts_nested_attributes_for :items, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

	validates_presence_of :query

	field :query
	field :start_at, :type => DateTime 
	field :end_at, :type => DateTime

	def self.events_for_date_range(start_d, end_d, find_options = {})
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end
end
