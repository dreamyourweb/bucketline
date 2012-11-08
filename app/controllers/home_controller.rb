class HomeController < ApplicationController
  def index
    if user_signed_in?
      initiative = current_user.user_roles.map{|ur| ur.initiative}.first
      if initiative
      	redirect_to root_url(:subdomain => initiative.slug) 
      else
      	flash[:notice] = "Je bent nog geen lid van een Bucket Line. Vraag om een uitnodiging van een lid, of begin er zelf een."
      end
    end
  end
end
