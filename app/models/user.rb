class User
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable, :confirmable,
         :invite_for => 1.week, :invite_key => {:email => Devise.email_regexp}, :validate_on_invite => :name

  include DeviseInvitable::Inviter

	has_one :profile, :autosave => true, :dependent => :destroy
	has_many :owned_projects, :class_name => "Project", :inverse_of => :owner
  has_many :owned_items, :class_name => "Item", :inverse_of => :owner
	#Facebook
	has_many :authentications, :dependent => :destroy
  has_many :user_roles, :dependent => :destroy #Roles such as admin are tracked via the userrole model and is the role of a user for a particular initiative

  #Identify invitation senders
  #has_many :invitations, :class_name => self.class.to_s, :as => :invited_by

  #Fields for invitations
  field :invitation_token, :type => String
  field :invitation_sent_at, :type => DateTime
  field :invitation_accepted_at, :type => DateTime
  field :invitation_limit, :type => Integer

  field :last_invited_for_initiative_id, :type => String

	field :super_admin, :type => Boolean, :default => false #Super admin is the owner and admin for the entire client instance
  field :name, :type => String, :null => false
	## Database authenticatable
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""
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

  def send_user_created_mail
    if self.user_roles.count == 0 #User performed a loose registration 
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
        if UserRole.where(:initiative_id => initiative.id, :user_id => self.id).last.admin
          initiative_admin_role = true
        end
      end
    end
    initiative_admin_role
  end

  def initiatives #the initiatives in which the user has a role
    user_roles = UserRole.where(:user_id => self.id).all
    initiatives = []
    user_roles.each do |user_role|
      initiatives << user_role.initiative
    end
    initiatives
  end
end
