class Item
  include Mongoid::Document
	include Mongoid::MultiParameterAttributes
	include EventCalendar
	has_event_calendar

	attr_accessible :start_at, :end_at, :name, :provided, :notes, :location, :amount

	belongs_to :question

	validates_numericality_of :amount

	field :name
	field :notes
	field :location
	field :amount, :type => Integer, :default => 1
	field :start_at, :type => DateTime 
	field :end_at, :type => DateTime

	def self.events_for_date_range(start_d, end_d, find_options = {})
		# Merging find_options until https://github.com/mongoid/mongoid/issues/829 is fixed
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end

	def provided
		if amount > 0
			false
		else
			amount = 0
			true
		end
	end

	def decrease_amount(number = 1)
		self.amount = self.amount - number.to_i
		self.save
	end
end
