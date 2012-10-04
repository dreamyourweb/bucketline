class ProjectCancellationMailer < MailForm::Base
	attribute :initiative
	attribute :project_query
	attribute :project_start_at
	attribute :project_end_at
	attribute :admin_email
	attribute :admin_contact
	attribute :recipients

  def headers
    {
      :subject => "Bucket Line - Een project waaraan je bijdraagt is geannuleerd",
      :to => %(<#{admin_email}>),
			:bcc => %(<#{recipients}>),
			:from => %(<#{admin_email}>)
    }
  end
end
