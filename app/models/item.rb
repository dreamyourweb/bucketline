class Item
  include Mongoid::Document
	include EventCalendar
	has_event_calendar

	embedded_in :question
	#has_one :comment

	field :description
	field :provided, :type => Boolean, :default => false
	field :notes
	field :start_datetime, :type => DateTime 
	field :end_datetime, :type => DateTime

	def self.events_for_date_range(start_d, end_d, find_options = {})
		# Merging find_options until https://github.com/mongoid/mongoid/issues/829 is fixed
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end

end
