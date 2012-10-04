class Link
  include Mongoid::Document
 	include Mongoid::Timestamps

	belongs_to :profile
	belongs_to :item

	validates_numericality_of :amount, :only_integer => true, :greater_than => 0

	field :amount, :type => Integer

    #Contribution mail is sent from items_controller, because if it is sent by an after_create hook, for some mysterious reason it is sent twice
	#after_save :send_contribution_mail 

	before_destroy :send_retreat_contribution_mail

	def send_contribution_mail
		p "SEND MAIL"
		item = self.item
		project = item.project
		if project
			initiative = project.initiative
		else #Contributed item does not have a project 
			initiative = item.initiative
		end
		contributor = self.profile.user
		if project && project.owner #There is a project owner to send this email to
			admin_email = project.owner.email #Get owner email
			email = ItemContributionMailer.new(:initiative => initiative.name, :admin_email => admin_email, :item_name => item.name, :amount => self.amount, :project_query => project.query, :project_date => project.start_at.to_date, :contributor_email => contributor.email, :contributor_name => contributor.name)
			email.deliver		
		elsif item.owner #There is an item owner to send this email to
			admin_email = item.owner.email #Get owner email
			email = ItemContributionMailer.new(:initiative => initiative.name, :admin_email => admin_email, :item_name => item.name, :amount => self.amount, :contributor_email => contributor.email, :contributor_name => contributor.name)
			email.deliver		
		end
	end

	def send_retreat_contribution_mail
		item = self.item
		project = self.item.project
		if project
			initiative = project.initiative
		else #Contributed item does not have a project 
			initiative = item.initiative
		end
		contributor = self.profile.user
		if project && project.owner #There is a project owner to send this email to
			admin_email = project.owner.email #Get owner email
			email = ItemRetreatContributionMailer.new(:initiative => initiative.name, :admin_email => admin_email, :item_name => item.name, :amount => self.amount, :project_query => project.query, :project_date => project.start_at.to_date, :contributor_email => contributor.email, :contributor_name => contributor.name)
			email.deliver		
		elsif item.owner #There is an item owner to send this email to
			admin_email = item.owner.email #Get owner email
			email = ItemRetreatContributionMailer.new(:initiative => initiative.name, :admin_email => admin_email, :item_name => item.name, :amount => self.amount, :contributor_email => contributor.email, :contributor_name => contributor.name)
			email.deliver		
		end
	end
end
