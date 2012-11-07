class ApplicationController < ActionController::Base
	include UrlHelper

  protect_from_forgery

	def authenticate_super_admin
		redirect_to login_url(:subdomain => false) unless current_user && current_user.super_admin
	end

	def authenticate_admin_for_initiative
		redirect_to login_url(:subdomain => false) unless current_user && (current_user.super_admin || current_user.user_roles.where(:initiative_id => @initiative.id).last.admin)
	end

	def authenticate_user_for_initiative
		redirect_to login_url(:subdomain => false) unless current_user && (current_user.super_admin || current_user.user_roles.where(:initiative_id => @initiative.id).last)
	end

	def get_profile
		if current_user
			@profile = current_user.profile
		end
	end

	def get_initiative
		if request.subdomain
			@initiative = Initiative.where(slug: request.subdomain).first
			if @initiative.nil?
				redirect_to "http://bucketline.nl"
			end
		end
	end

	protected

	def authenticate_inviter!
		authenticate_user_for_initiative
	end
end
