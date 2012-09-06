class LinksController < ApplicationController
	before_filter :authenticate_admin

	def index
		if params[:show] == "all"
			@links = Link.all
		else	
			@links = Link.where(:end_at.gte => Time.now)
		end
		@loose_links = Link.where(:project_id => nil, :project_query => nil)

		@projects = []
		@links.each do |link|
			if !link.project_id.nil?
				@projects << Project.find(link.project_id)
			end
		end
		@projects = @projects.uniq
	end
end

