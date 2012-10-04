class ProjectPlacementMailer < MailForm::Base
  	attribute :initiative
	attribute :project_query
	attribute :project_start_at
	attribute :project_end_at
	attribute :project_dayparts
	attribute :project_remark
	attribute :items
	attribute :location
	attribute :admin_email
	attribute :admin_contact
	attribute :recipients

  def headers
    {
      :subject => "Bucket Line - Er is een nieuw project geplaatst",
      :to => %(<#{admin_email}>),
			:bcc => %(<#{recipients}>),
			:from => %(<#{admin_email}>)
    }
  end
end
