class Link
  include Mongoid::Document
 	include Mongoid::Timestamps

	belongs_to :profile
	belongs_to :item

	validates_numericality_of :amount, :only_integer => true, :greater_than => 0

	field :amount, :type => Integer

	after_save :send_contribution_mail
	before_destroy :send_retreat_contribution_mail

	def send_contribution_mail
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
