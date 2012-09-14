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
      :subject => "Bucketline - Een project waaraan je bijdraagt is geannuleerd",
      :to => %(<#{admin_email}>),
			:bcc => %(<#{recipients}>),
			:from => %(<#{admin_email}>)
    }
  end
end
