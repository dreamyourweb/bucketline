class LinksController < ApplicationController
	before_filter :authenticate_admin, :only => [:index]
	before_filter :authenticate_user, :only => [:create]

	def index
		if params[:show] == "all"
			@projects = Project.all
		else	
			@projects = Project.where(:end_at.gte => Date.today)
		end
	end

	#def create
	#	@item = Item.find(params[:id])
	#	@link = @item.links.create(:amount => params[:amount])
	#	@profile = current_user.profile
	#	@profile.build(@link)
	#	@profile.save
	#end
end

