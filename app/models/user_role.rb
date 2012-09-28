class UserRole
	include Mongoid::Document
	include Mongoid::Timestamps

	#A user role is the role a user has for a particular initiative. User can be admin.
	belongs_to :user
	belongs_to :initiative

	field :admin, :type => Boolean, :default => false

	after_save :ensure_only_one_user_role_per_user_initiative_couple

	def ensure_only_one_user_role_per_user_initiative_couple
		same_user_roles_as_self = UserRole.where(:initiative_id => self.initiative_id, :user_id => self.user_id)
		if same_user_roles_as_self.count > 1 #duplicates are present
			same_user_roles_as_self.first.delete
		end
	end
end
