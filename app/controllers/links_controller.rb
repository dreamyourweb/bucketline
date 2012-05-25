class LinksController < ApplicationController
	before_filter :authenticate_admin

	def index
		if params[:show] == "all"
			@links = Link.all
		else	
			@links = Link.where(:item_end_at.gte => Date.today)
		end
		@projects = []
		@links.each do |link|
			@projects << link.project_query
		end
		@projects = @projects.uniq

	end
end

