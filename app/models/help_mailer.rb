class HelpMailer < MailForm::Base
	attribute :project
	attribute :item
	attribute :number
  attribute :initiative_admin_emails

  def headers
    {
      :subject => "Bucket Line - Iemand heeft aangegeven om iets bij te dragen",
      :to => %(<#{initiative_admin_emails}>),
      :from => "no-reply@bucketline.nl"
    }
  end
end
