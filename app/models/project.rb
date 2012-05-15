class Project
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes
	include EventCalendar
	has_event_calendar
	
	has_many :items, :autosave => true, :dependent => :delete
	
	accepts_nested_attributes_for :items, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

	validates_presence_of :query

	after_create :send_project_placement_mail
	before_save :trim_daypart
	before_destroy :remove_links

	field :query
	field :start_at, :type => Date
	field :end_at, :type => Date
	field :daypart
	field :remark, :type => String

	def remove_links
		@links = []
		self.items.all.each do |item|
			@item_links = Link.where(:item_id => item.id).all.entries
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

	def send_project_placement_mail
		mailing_list = []
		AvailableDate.all.each do |date|
			if self.start_at <= date.date && self.end_at >= date.date && date.profile.send_project_placement_mail
				mailing_list << date.profile.user.email
			end
		end
		User.all.each do |user|
			if user.profile.always_send_project_placement_mail
				mailing_list << user.email
			end
		end
		unique_mailing_list = mailing_list.uniq
		unique_mailing_list.each do |mail|
			email = ProjectPlacementMailer.new(:email => mail, :project_query => self.query, :project_start_at => self.start_at, :project_end_at => self.end_at, :project_dayparts => self.daypart.to_sentence)
			email.deliver
		end
	end
end
