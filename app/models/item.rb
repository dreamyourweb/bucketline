class Item
  include Mongoid::Document
	include Mongoid::MultiParameterAttributes

	attr_accessible :start_at, :end_at, :name, :type, :notes, :location, :amount, :last_provided_by

	belongs_to :project

	validates_numericality_of :amount
	#validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

	field :provided_by_last_user_name
	field :name
	field :type
	field :notes
	field :location
	field :amount, :type => Integer, :default => 1
	field :start_at, :type => DateTime 
	field :end_at, :type => DateTime
	
	def provided
		if amount > 0
			false
		else
			true
		end
	end

	def decrease_amount(number = 1, current_user_name)
		self.amount = self.amount - number.to_i
		if self.amount < 0
			self.amount = 0
		end
		self.provided_by_last_user_name = current_user_name
		self.save
	end

	def translate_type
		if self.type == "help"
			"Handjes"
		elsif self.type == "tools"
			"Gereedschap"
		else
			"Materiaal"
		end
	end
end
