class Item
  include Mongoid::Document
	include Mongoid::MultiParameterAttributes

	attr_accessible :start_at, :end_at, :name, :type, :amount, :last_provided_by_user_name, :daypart

	belongs_to :project

	validates_numericality_of :amount
	#validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

	field :provided_by_last_user_name, :default => "Anoniempje"
	field :name
	field :type
	field :amount, :type => Integer, :default => 1
	field :start_at, :type => Date
	field :end_at, :type => Date
	field :daypart
	
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
		elsif self.type == "tool"
			"Gereedschap"
		else
			"Materiaal"
		end
	end
end
