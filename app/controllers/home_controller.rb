class HomeController < ApplicationController
  def index
    if user_signed_in?
      initiative = current_user.user_roles.map{|ur| ur.initiative}.first
      redirect_to root_url(:subdomain => initiative.name) 
    end
  end
end
