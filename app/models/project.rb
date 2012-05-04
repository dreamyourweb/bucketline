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

	field :query
	field :start_at, :type => Date
	field :end_at, :type => Date
	field :daypart
	field :remark, :type => String

	def self.events_for_date_range(start_d, end_d, find_options = {})
		where(find_options.merge(self.end_at_field.to_sym.lt => end_d.to_time.utc,
		self.start_at_field.to_sym.gt => start_d.to_time.utc)).asc(self.start_at_field)
	end

	def send_project_placement_mail
		mailing_list = []
		AvailableDate.all.each do |date|
			if self.start_at <= date.date && self.end_at >= date.date
				mailing_list << date.profile.user.email
			end
		end
		mailing_list.uniq!
		mailing_list.each do |mail|
			email = ProjectPlacementMailer.new(:email => mail, :project_query => self.query, :project_start_at => self.start_at.to_s, :project_end_at => self.end_at.to_s, :project_dayparts => self.daypart.to_s)
			email.deliver
		end
	end
end
