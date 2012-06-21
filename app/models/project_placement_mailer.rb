class ProjectPlacementMailer < MailForm::Base
	attribute :project_query
	attribute :project_start_at
	attribute :project_end_at
	attribute :project_dayparts
	attribute :project_remark
	attribute :items
	attribute :admin_email
	attribute :recipients

  def headers
    {
      :subject => "Huis van Overvloed - Er is een nieuw project geplaatst",
      :to => %(<#{admin_email}>),
			:bcc => %(<#{recipients}>),
			:from => %(<#{admin_email}>)
    }
  end
end
