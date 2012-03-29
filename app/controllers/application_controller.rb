class ApplicationController < ActionController::Base
  protect_from_forgery

	def authenticate_admin
		redirect_to login_url unless current_user && current_user.admin
	end
end
