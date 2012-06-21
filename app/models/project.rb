class Project
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes
	include EventCalendar
	has_event_calendar
	
	has_many :items, :autosave => true, :dependent => :delete
	belongs_to :owner, :class_name => "User", :inverse_of => :owned_projects
	
	accepts_nested_attributes_for :items, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

	validates_presence_of :query
	validates_uniqueness_of :query

	before_save :trim_daypart
	before_destroy :remove_links

	field :query
	field :start_at, :type => Date
	field :end_at, :type => Date
	field :daypart
	field :remark, :type => String
	field :success, :type => Boolean, :default => false

	def remove_links
		@links = []
		self.items.all.each do |item|
			@item_links = Link.where(:item_id => item.id)
			@item_links.each do |item_link|
				@links << item_link
			end
		end
		@links.each do |link|
			Link.find(link.id).destroy
		end
	end

	def trim_daypart
		self.daypart.delete("")
	end

	def self.events_for_date_range(start_d, end_d, find_options = {})
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end

	#Items are created after project is created, so if this method is called by an after_create hook, project.items is still empty when the mail is sent. That's why it is called by the controller.
	def send_project_placement_mail
		mailing_list = []
		item_list = self.build_items_for_mailer
		#AvailableDate.all.each do |date|
		#	if self.start_at <= date.date && self.end_at >= date.date && date.profile.send_project_placement_mail && self.owner.email != date.profile.user.email #Get all the to-be-reminded-users that are not the owner of this project
		#		mailing_list << date.profile.user.email
		#	end
		#end
		User.all.each do |user|
			if user.profile.always_send_project_placement_mail && user.email != self.owner.email #Get all the to-be-reminded-users that are not the owner of this project
				mailing_list << user.email
			end
		end
		unique_mailing_list = mailing_list.uniq
		email = ProjectPlacementMailer.new(:recipients => unique_mailing_list, :admin_email => self.owner.email, :project_query => self.query, :project_start_at => self.start_at, :project_end_at => self.end_at, :project_dayparts => self.daypart.to_sentence, :items => item_list, :project_remark => self.remark)
		email.deliver
	end

	def build_items_for_mailer
		item_list = []
		self.items.all.each do |item|
			item_list << item.amount.to_s + " " + item.name
		end
		item_list.to_sentence
	end

	def providing_user(user) #checks if user is providing something for this project
		providing = false
		self.items.each do |item|
			if item.profile_ids.include?(user.profile.id)
				providing = true
			end
		end
		providing
	end
end
