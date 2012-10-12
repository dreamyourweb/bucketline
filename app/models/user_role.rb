class UserRole
	include Mongoid::Document
	include Mongoid::Timestamps

	attr_accessible :admin, :user_id, :initiative_id

	#A user role is the role a user has for a particular initiative. User can be admin.
	belongs_to :user
	belongs_to :initiative

	field :admin, :type => Boolean, :default => false

	after_save :ensure_only_one_user_role_per_user_initiative_couple
	after_create :send_user_created_mail

	def ensure_only_one_user_role_per_user_initiative_couple
		same_user_roles_as_self = UserRole.where(:initiative_id => self.initiative_id, :user_id => self.user_id)
		if same_user_roles_as_self.count > 1 #duplicates are present
			same_user_roles_as_self.first.delete
		end
	end

	def send_user_created_mail
		UserRole.where(:admin => true, :initiative_id => self.initiative.id).each do |initiative_admin_role|
			mail = UserCreatedMailer.new(:email => initiative_admin_role.user.email, :user_email => self.user.email, :initiative => self.initiative.name)
			mail.deliver
		end
	end

	#Sent from controller
	def send_user_role_update_mail
		mail = UserRoleUpdateMailer.new(:initiative => self.initiative.name, :email => self.user.email, :role => self.admin ? "Admin" : "Gebruiker")
		mail.deliver
	end
end
