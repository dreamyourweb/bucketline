class Initiative
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :location, :type => String
  field :description, :type => String
  field :slug, :type => String

  field :patient_email, type: String
  field :patient_name, type: String
  field :buddy_email, type: String
  field :buddy_name, type: String

  before_validation :build_slug

  validates_presence_of :name
  validates_uniqueness_of :slug, :message => "Naam bestaat al."
  validates_exclusion_of :slug, :in => ["www", "bucketline"], :message => "Naam is niet toegestaan."
  validates_format_of :patient_email, with: /[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/i, allow_blank: true
  validates_format_of :buddy_email, with: /[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/i, allow_blank: true

  has_many :user_roles, :dependent => :destroy #Roles for an initiative such as admin or superadmin are tracked via the userrole model
  has_many :invitations, :dependent => :destroy, as: :invitationable

	has_many :projects #, :dependent => :destroy
	has_many :items #, :dependent => :destroy #loose items

	def build_slug
		self.slug = self.name.downcase.gsub(' ', '-').gsub("'", "")
	end

	def admins
		user_roles = UserRole.where(:initiative_id => self.id, :admin => true)
		admins = []
		user_roles.each do |user_role|
			if user_role.user
				admins << user_role.user
			end
		end
		admins
	end

	def users
		user_roles = UserRole.where(:initiative_id => self.id)
		users = []
		user_roles.each do |user_role|
			if user_role.user
				users << user_role.user
			end
		end
		users
	end

  def events_hash_for_month(date=Date.today)
    events_hash = {}
    self.projects.where(start_at: date.beginning_of_month..date.end_of_month).each do |project|
      events_hash[project.start_at.day] = project
    end
    return events_hash
  end

  def user_is_admin?(user)
    (UserRole.where(:initiative_id => self.id, user_id: user.id).present? and UserRole.where(:initiative_id => self.id, user_id: user.id).first.admin) || user.super_admin
  end

end
