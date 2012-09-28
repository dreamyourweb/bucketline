class LinksController < ApplicationController
	before_filter :get_initiative
	before_filter :authenticate_admin_for_initiative, :only => [:index]
	#before_filter :authenticate_user, :only => [:create]

	def index
		if params[:show] == "all"
			@projects = @initiative.projects.all
		else	
			@projects = @initiative.projects.where(:end_at.gte => Date.today)
		end
		@loose_items = @initiative.items
	end
end

