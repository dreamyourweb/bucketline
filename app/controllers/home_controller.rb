class HomeController < ApplicationController

  # before_filter :authenticate_user!

  def index
    if user_signed_in?
      initiative = current_user.user_roles.map{|ur| ur.initiative}.first
      if initiative
      	redirect_to root_url(:subdomain => initiative.slug) 
      else
      	flash[:notice] = "Welkom bij Bucket Line."
      end
    end
  end

  def disclaimer
  end

  def terms_and_conditions  
  end

end
