module UserRolesHelper
	def get_user_role(initiative, user)
		user_role = UserRole.where(:initiative_id => initiative.id, :user_id => user.id).first
	end
end
