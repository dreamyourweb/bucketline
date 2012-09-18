class Item
	include Mongoid::Document
	include Mongoid::MultiParameterAttributes

	attr_accessible :name, :type, :amount, :description, :owner_id, :success

	belongs_to :project
	belongs_to :owner, :class_name => "User", :inverse_of => :owned_items #Owner of loose item
	has_and_belongs_to_many :profiles, :dependent => :nullify #All the users that have contributed to this item

	before_destroy :remove_links

	validates_numericality_of :amount
	#validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

	#field :provided_by_last_user_name, :default => "Anoniempje"
	field :name
	field :description
	field :type
	field :amount, :type => Integer, :default => 1
	field :success, :type => Boolean, :default => false

	def remove_links
		@links = Link.where(:item_id => self.id)
		@links.destroy
	end

	def items_left
		@items_provided = 0
		@links = Link.where(:item_id => self.id)
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

	def link_to_profile(amount, profile)
		self.profiles << profile
	end

	def remove_profile(profile)
		self.profiles.delete(profile)
	end

	#def decrease_amount(number = 1, current_user_name)
	#	self.amount = self.amount - number.to_i
	#	if self.amount < 0
	#		self.amount = 0
	#	end
	#	self.provided_by_last_user_name = current_user_name
	#	self.save
	#end

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
		if self.profile_ids.include?(user.profile.id)
			providing = true
		end
		providing
	end
end
