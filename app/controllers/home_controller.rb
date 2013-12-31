class HomeController < ApplicationController

  # before_filter :authenticate_user!

  def index
    if user_signed_in?
      initiative = current_user.user_roles.map{|ur| ur.initiative}.first
      bucket_group = current_user.bucket_groups.first
      if initiative.present?
      	redirect_to root_url(:subdomain => initiative.slug) 
      elsif bucket_group.present?
        redirect_to bucket_group_url(bucket_group, subdomain: false)
      else
        redirect_to profile_url(current_user.profile, :subdomain => false)
      end
    else
      redirect_to "http://www.bucketline.nl"
    end
  end

  def disclaimer
  end

  def terms_and_conditions  
  end

end
