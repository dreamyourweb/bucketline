class User
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable, :confirmable

	has_one :profile, :autosave => true, :dependent => :destroy
	has_many :owned_projects, :class_name => "Project", :inverse_of => :owner
  has_many :owned_items, :class_name => "Item", :inverse_of => :owner
	#Facebook
	has_many :authentications, :dependent => :destroy
  has_many :user_roles, :dependent => :destroy #Roles such as admin are tracked via the userrole model and is the role of a user for a particular initiative

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

  before_save :check_or_create_profile
  after_create :send_user_created_mail

	def check_or_create_profile
		if self.profile.nil?
			self.profile = Profile.create
		end
	end

	def send_user_created_mail
		User.where(:admin => true).each do |admin|
			mail = UserCreatedMailer.new(:email => admin.email, :user_email => self.email)
			mail.deliver
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
end
