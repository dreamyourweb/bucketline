class Item
	include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes

	attr_accessible :name, :type, :amount, :description, :owner_id, :success

	belongs_to :initiative #loose items for wishlist
	belongs_to :project
	has_many :links, :dependent => :destroy #All the users that have contributed to this item
	belongs_to :owner, :class_name => "User", :inverse_of => :owned_items #Owner of loose item

	before_destroy :send_item_cancellation_mail

	#The creation of new items is checked every hour by a cronjob. A bulk email is then sent for all new items at once.

	validates_numericality_of :amount
	validates_presence_of :name
	#validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

	field :name
	field :description
	field :type
	field :amount, :type => Integer, :default => 1
	field :success, :type => Boolean, :default => false

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

	def send_item_cancellation_mail
		mailing_list = self.contributor_emails
		if !mailing_list.empty?
			email = ItemCancellationMailer.new(:initiative => self.initiative.name, :item_name => self.name, :recipients => mailing_list, :admin_contact => ("email: " + self.owner.email + ", tel: " + self.owner.profile.phone), :admin_email => self.owner.email)
			email.deliver
		end
	end

	def contributor_emails
		mailing_list = []
		self.links.all.each do |link|
			profile = link.profile
			if profile.send_project_cancellation_mail && self.owner != profile.user
				mailing_list << profile.user.email
			end
		end
		unique_mailing_list = "<" + mailing_list.uniq.join(">,<") + ">"
	end
end
