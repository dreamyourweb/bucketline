class Item
  include Mongoid::Document
	include Mongoid::MultiParameterAttributes

	attr_accessible :start_at, :end_at, :name, :type, :notes, :location, :amount

	belongs_to :project

	validates_numericality_of :amount
	#validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

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
			self.update_attributes(:amount => 0)
			true
		end
	end

	def decrease_amount(number = 1)
		self.amount = self.amount - number.to_i
		self.save
	end
end
