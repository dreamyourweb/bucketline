class User
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

	has_one :profile, :autosave => true, :dependent => :destroy
	has_many :owned_projects, :class_name => "Project", :inverse_of => :owner
  has_many :owned_items, :class_name => "Item", :inverse_of => :owner
	#Facebook
	has_many :authentications, :dependent => :destroy
  has_many :user_roles, :dependent => :destroy #Roles such as admin are tracked via the userrole model and is the role of a user for a particular initiative
  # has_many :bucket_group_users, dependent: :destroy

	field :super_admin, :type => Mongoid::Boolean, :default => false #Super admin is the owner and admin for the entire client instance
  field :invited, :type => Mongoid::Boolean, :default => false #Was user invited or did he register on his own 

  field :name, :type => String
	## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time
  ## Rememberable
  field :remember_created_at, :type => Time
  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  ## Encryptable
  # field :password_salt, :type => String
  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable
                                               # 
  field :terms_and_conditions_accepted, :type => Mongoid::Boolean

  field :bucketline_creator_role, type: Mongoid::Boolean, default: false
  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
  ## Token authenticatable
  # field :authentication_token, :type => String

  #TODO: MAKE TOKEN UNIQUE
  #validates_uniqueness_of :invitation_token

  before_save :check_or_create_profile
  after_create :send_user_created_mail

  validates_acceptance_of :terms_and_conditions_accepted, accept: true#, :message => "must be checked to be able to register."
  validates_presence_of :name, :email, :encrypted_password


  def send_user_created_mail
    if self.invited == false #User performed a loose registration
      mail = UserCreatedMailer.new(:email => "info@bucketline.nl", :user_email => self.email, :initiative => "Losse aanmelding, neem contact op.")
      mail.deliver
    end
  end

	def check_or_create_profile
		if self.profile.nil?
			self.profile = Profile.create
		end
	end

	def apply_omniauth(auth)
		# In previous omniauth, 'user_info' was used in place of 'raw_info'
		self.email = auth['extra']['raw_info']['email']
		#Automatically confirm
		self.confirmed_at = Time.now
		# Again, saving token is optional. If you haven't created the column in authentications table, this will fail
		auth = self.authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
		auth.save
	end

  def initiative_admin(initiatives) #Is the user super admin or normal admin for one or more of these initiatives?
    initiative_admin_role = false
    if self.super_admin
      initiative_admin_role = true
    else
      initiatives.to_a.each do |initiative|
        if initiative && UserRole.where(:initiative_id => initiative.id, :user_id => self.id).last.admin
          initiative_admin_role = true
        end
      end
    end
    initiative_admin_role
  end

  def bucket_group_admin?(bucket_group)
    c = bucket_group.users.includes(:user).where(user_id: self.id)
    if c.present?
      return c.first.admin
    else
      return self.super_admin || false
    end
  end

  def initiatives #the initiatives in which the user has a role
    user_roles = UserRole.where(:user_id => self.id).all
    initiatives = []
    user_roles.each do |user_role|
      initiatives << user_role.initiative
    end
    initiatives
  end

  def bucket_groups
    BucketGroup.where('users.user_id' => self.id).asc(:name)
  end

  def can_create_bucket_lines?
    return self.bucketline_creator_role || self.super_admin 
  end

end
