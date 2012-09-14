class LinksController < ApplicationController
	before_filter :authenticate_admin, :only => [:index]
	#before_filter :authenticate_user, :only => [:create]
	before_filter :get_initiative

	def index
		if params[:show] == "all"
			@projects = Project.all
		else	
			@projects = Project.where(:end_at.gte => Date.today)
		end
		@loose_items = @initiative.items
	end
end

