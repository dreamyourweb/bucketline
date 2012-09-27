class ApplicationController < ActionController::Base
  protect_from_forgery

	def authenticate_super_admin
		redirect_to login_url unless current_user && current_user.super_admin
	end

	def authenticate_admin_for_initiative
		redirect_to login_url unless current_user && (current_user.user_role.find(@initiative).admin || current_user.super_admin)
	end

	def authenticate_user_for_initiative
		redirect_to login_url unless current_user && (current_user.user_role.find(@initiative) || current_user.super_admin)
	end

	def get_profile
		if current_user
			@profile = current_user.profile
		end
	end

	def get_initiative
		if params[:initiative_id]
			@initiative = Initiative.find(params[:initiative_id])
		else
			@initiative = Initiative.find(session[:initiative_id])
		end
	end
end
