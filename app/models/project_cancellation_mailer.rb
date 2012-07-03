class ProjectCancellationMailer < MailForm::Base
	attribute :project_query
	attribute :project_start_at
	attribute :project_end_at
	attribute :email
	attribute :admin_email
	attribute :admin_contact
	attribute :recipients

  def headers
    {
      :subject => "Huis van Overvloed - Een project waaraan je bijdraagt is geannuleerd",
      :to => "no-reply@waardeverbinder.nl",
			:bcc => %(<#{recipients}>),
			:from => "no-reply@waardeverbinder.nl"
    }
  end
end
