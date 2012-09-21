class Item
	include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes

	attr_accessible :name, :type, :amount, :description, :owner_id, :success

	belongs_to :project
	belongs_to :owner, :class_name => "User", :inverse_of => :owned_items #Owner of loose item
	has_and_belongs_to_many :profiles, :dependent => :nullify #All the users that have contributed to this item

	before_destroy :remove_links, :send_item_cancellation_mail
	#The creation of new items is checked every hour by a cronjob. A bulk email is then sent for all new items at once.

	validates_numericality_of :amount
	#validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

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

	def send_item_cancellation_mail
		mailing_list = self.contributor_emails
		if !mailing_list.empty?
			email = ItemCancellationMailer.new(:item_name => self.name, :recipients => mailing_list, :admin_contact => ("email: " + self.owner.email + ", tel: " + self.owner.profile.phone), :admin_email => self.owner.email)
			email.deliver
		end
	end

	def contributor_emails
		mailing_list = []
		self.profiles.all.each do |profile|
			if profile.send_project_cancellation_mail && self.owner != profile.user
				mailing_list << profile.user.email
			end
		end
		unique_mailing_list = mailing_list.uniq.join(">,<")
	end
end
