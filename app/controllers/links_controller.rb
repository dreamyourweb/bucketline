class LinksController < ApplicationController
	before_filter :authenticate_admin

	def index
		@links = Link.where(:item_end_at.gte => Date.today)
		@projects = []
		@links.each do |link|
			@projects << link.project_query
		end
		@projects = @projects.uniq

	end
end

