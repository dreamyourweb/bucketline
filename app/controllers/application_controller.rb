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

	def authenticate_user_for_bucket_group
		redirect_to login_url(:subdomain => false) unless current_user && (current_user.super_admin || @bucket_group.user_is_member?(current_user))
	end

	def authenticate_admin_for_bucket_group
		redirect_to login_url(:subdomain => false) unless current_user && (current_user.super_admin || @bucket_group.user_is_admin?(current_user) )
	end

	def authenticate_bucket_line_creator
		redirect_to login_url(:subdomain => false) unless (current_user && current_user.can_create_bucket_lines?)
	end

	def get_profile
		if current_user
			@profile = current_user.profile
		end
	end

	def get_initiative
		if request.subdomain
			@initiative = Initiative.where(slug: request.subdomain).first
			if @initiative.nil? && request.path_parameters[:controller] != "profiles" && request.path_parameters[:controller] != "admin" #&& !(request.path_parameters[:controller] == "initiatives" && request.path_parameters[:action] == "index")
				redirect_to root_url(:subdomain => false)
			end
		end
	end

	before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :terms_and_conditions_accepted
  end

  	def after_sign_out_path_for(resource)
  		"http://bucketline.nl"
	end
	
	protected

	def authenticate_inviter!
		authenticate_user_for_initiative
	end
end
