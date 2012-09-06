class Item
  include Mongoid::Document
	include Mongoid::MultiParameterAttributes

	attr_accessible :name, :type, :amount, :description

	belongs_to :project
	has_many :links, :dependent => :destroy #All the users that have contributed to this item

	validates_numericality_of :amount
	#validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

	#field :provided_by_last_user_name, :default => "Anoniempje"
	field :name
	field :description
	field :type
	field :amount, :type => Integer, :default => 1

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
	def providing_user(user) #checks if user is providing this item
		providing = false
		if Link.where(:profile_id => user.profile.id, :item_id => self.id).count > 0
			providing = true
		end
		providing
	end
end
