class Link
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes

	field :item_id
	field :profile_id
	field :amount

	field :project_query
	field :item_name
	field :item_total_amount
	field :item_start_at, :type => Date
	field :item_end_at, :type => Date
	field :item_daypart
	field :contributor_name
	field :contributor_email

	before_save :consolidate_links, :populate_properties

	def consolidate_links #add all duplicate links together
		@duplicate_link = Link.where(:item_id => self.item_id, :profile_id => self.profile_id).first
		if !@duplicate_link.nil?
			self.amount += @duplicate_link.amount
			@duplicate_link.delete
		end
	end

	def populate_properties #populate properties on creation, so admin dashboard loads faster
		@item = Item.find(self.item_id)
		@profile = Profile.find(self.profile_id)
		self.project_query = @item.project.query
		self.item_name = @item.name
		self.item_total_amount = @item.amount
		self.item_start_at = @item.start_at
		self.item_end_at = @item.end_at
		self.item_daypart = @item.daypart
		self.contributor_name = @profile.name
		self.contributor_email = @profile.user.email
	end
end
