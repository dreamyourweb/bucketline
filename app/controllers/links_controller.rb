class LinksController < ApplicationController
	before_filter :authenticate_admin

	def index
		@links = Link.all
	end
end

