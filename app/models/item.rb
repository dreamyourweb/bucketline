class Item
  include Mongoid::Document
	include Mongoid::MultiParameterAttributes

	attr_accessible :start_at, :end_at, :name, :type, :amount, :daypart

	belongs_to :project
	has_many :links, :dependent => :destroy #All the users that have contributed to this item

	before_save :trim_daypart

	validates_numericality_of :amount
	#validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

	#field :provided_by_last_user_name, :default => "Anoniempje"
	field :name
	field :type
	field :amount, :type => Integer, :default => 1
	field :start_at, :type => Date
	field :end_at, :type => Date
	field :daypart

	def trim_daypart
		if !self.daypart.nil?
			self.daypart.delete("")
		end
	end

	def items_left
		@items_provided = 0
		@links = self.links
		@links.each do |link|
			@items_provided += link.amount
		end
		self.amount - @items_provided
	end
	
	def provided
		if self.items_left > 0
			false
		else
			true
		end
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
