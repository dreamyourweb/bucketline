class ApplicationController < ActionController::Base
  protect_from_forgery

	def authenticate_admin
		redirect_to login_url unless current_user && current_user.admin
	end

	def get_profile
		if current_user
			@profile = current_user.profile
		end
	end

	def get_initiative
		@initiative = Initiative.find(session[:initiative_id])
	end
end
