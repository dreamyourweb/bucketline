class HomeController < ApplicationController

  # before_filter :authenticate_user!

  def index
    if user_signed_in?
      initiative = current_user.user_roles.map{|ur| ur.initiative}.first
      if initiative
      	redirect_to root_url(:subdomain => initiative.slug) 
      else
      	flash[:notice] = "Welkom bij Bucket Line. Als je je net hebt aangemeld, nemen we binnenkort contact op om je verder op weg te helpen. Voor losse vragen kun je een e-mail sturen naar info@bucketline.nl"
      end
    end
  end

  def disclaimer
  end

  def terms_and_conditions
    
  end


end
