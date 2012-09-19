class Link
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes

	field :item_id
	field :profile_id
	field :amount
	field :project_id

	field :project_query
	field :item_name
	field :item_total_amount
	field :start_at, :type => DateTime
	field :end_at, :type => DateTime
	field :contributor_name
	field :contributor_email

	before_save :consolidate_links, :populate_properties
	after_save :send_contribution_mail
	before_destroy :send_retreat_contribution_mail

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
		self.item_name = @item.name
		self.item_total_amount = @item.amount
		self.contributor_name = @profile.name
		self.contributor_email = @profile.user.email
		if @item.project #item belongs to a project
			self.project_id = @item.project.id
			self.project_query = @item.project.query
			self.start_at = @item.project.start_at
			self.end_at = @item.project.end_at
		end
	end

	def send_contribution_mail
		item = Item.find(self.item_id)
		if self.project_id #There is a project owner to send this email to
			admin_email = Project.find(self.project_id).owner.email #Get owner email
			email = ItemContributionMailer.new(:admin_email => admin_email, :item_name => self.item_name, :amount => self.amount, :project_query => self.project_query, :contributor_email => self.contributor_email, :contributor_name => self.contributor_name)
			email.deliver		
		elsif item.owner #There is an item owner to send this email to
			admin_email = item.owner.email #Get owner email
			email = ItemContributionMailer.new(:admin_email => admin_email, :item_name => self.item_name, :amount => self.amount, :contributor_email => self.contributor_email, :contributor_name => self.contributor_name)
			email.deliver		
		end
	end

	def send_retreat_contribution_mail
		item = Item.find(self.item_id)
		if self.project_id #There is a project owner to send this email to
			admin_email = Project.find(self.project_id).owner.email #Get owner email
			email = ItemRetreatContributionMailer.new(:admin_email => admin_email, :item_name => self.item_name, :amount => self.amount, :project_query => self.project_query, :contributor_email => self.contributor_email, :contributor_name => self.contributor_name)
			email.deliver		
		elsif item.owner #There is an item owner to send this email to
			admin_email = item.owner.email #Get owner email
			email = ItemRetreatContributionMailer.new(:admin_email => admin_email, :item_name => self.item_name, :amount => self.amount, :contributor_email => self.contributor_email, :contributor_name => self.contributor_name)
			email.deliver		
		end
	end
end
