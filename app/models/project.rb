class Project
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes
	include EventCalendar
	has_event_calendar
	
	has_many :items, :autosave => true, :dependent => :delete
	belongs_to :owner, :class_name => "User", :inverse_of => :owned_projects
	
	accepts_nested_attributes_for :items, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

	validates_presence_of :query, :input_date, :input_start_at, :input_end_at
	validate :input_end_at_greater_than_input_start_at

	before_save :set_dates
	#after_update :send_project_update_mail
	#after_create :send_project_placement_mail
	before_destroy :remove_links, :send_project_cancellation_mail

	field :query
	field :daypart #depricated
	field :input_date, :type => Date
	field :input_start_at, :type => Time
	field :input_end_at, :type => Time
	field :start_at, :type => DateTime
	field :end_at, :type => DateTime
	field :location, :type => String, :default => ""
	field :remark, :type => String
	field :success, :type => Boolean, :default => false
 
	def input_end_at_greater_than_input_start_at
	 unless self.input_end_at.to_i >= self.input_start_at.to_i
	   errors.add :input_end_at, "moet groter zijn dan begintijd"
	   return false
	 end
	 true
	end

	def set_dates
		unless input_date.nil? || input_start_at.nil? || input_end_at.nil?
			self.start_at = DateTime.new(input_date.year, input_date.month, input_date.day, input_start_at.hour, input_start_at.min)
			self.end_at = DateTime.new(input_date.year, input_date.month, input_date.day, input_end_at.hour, input_end_at.min)
		end
	end

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

	def self.events_for_date_range(start_d, end_d, find_options = {})
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end

	def send_project_cancellation_mail
		mailing_list = self.contributor_emails
		if !mailing_list.empty?
			email = ProjectCancellationMailer.new(:recipients => mailing_list, :admin_email => self.owner.email, :admin_contact => ("email: " + self.owner.email + ", tel: " + self.owner.profile.phone), :project_query => self.query, :project_start_at => self.start_at, :project_end_at => self.end_at)
			email.deliver
		end
	end

	#Items are updated after project is updated, so if this method is called by an after_create hook, project.items is old when the mail is sent. That's why it is called by the controller.
	def send_project_update_mail
		mailing_list = self.contributor_emails
		if !mailing_list.empty?
			email = ProjectUpdateMailer.new(:recipients => mailing_list, :admin_contact => ("email: " + self.owner.email + ", tel: " + self.owner.profile.phone), :admin_email => self.owner.email, :project_query => self.query, :project_start_at => self.start_at, :project_end_at => self.end_at, :update_notice => true, :project_completion => (if self.success then "Afgerond" else "Onafgerond" end))
			email.deliver
		end
	end

	#Items are created after project is created, so if this method is called by an after_create hook, project.items is still empty when the mail is sent. That's why it is called by the controller.
	def send_project_placement_mail
		mailing_list = []
		item_list = self.build_items_for_mailer
		User.all.each do |user|
			if user.profile.always_send_project_placement_mail && user.email != self.owner.email #Get all the to-be-reminded-users that are not the owner of this project
				mailing_list << user.email
			end
		end
		unique_mailing_list = "<" + mailing_list.uniq.join(">,<") + ">"
		email = ProjectPlacementMailer.new(:recipients => unique_mailing_list, :admin_email => self.owner.email, :admin_contact => ("email: " + self.owner.email + ", tel: " + self.owner.profile.phone), :location => self.location, :project_query => self.query, :project_start_at => self.start_at, :project_end_at => self.end_at, :items => item_list, :project_remark => self.remark)
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

	def contributor_emails
		mailing_list = []
		self.items.all.each do |item|
			item.profiles.all.each do |profile|
				if profile.send_project_cancellation_mail && self.owner != profile.user
					mailing_list << profile.user.email
				end
			end
		end
		unique_mailing_list = mailing_list.uniq.join(">,<")
	end

	def contributing_users
		users = []
		self.items.all.each do |item|
			item.profiles.all.each do |profile|
				users << profile.user
			end
		end
		unique_users = users.uniq
	end
end
