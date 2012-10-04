class ItemCancellationMailer < MailForm::Base
  attribute :initiative
	attribute :item_name
	attribute :admin_contact
  attribute :admin_email
	attribute :recipients

  def headers
    {
      :subject => "Bucket Line - Een item waaraan je bijdraagt is geannuleerd",
      :to => %(<#{admin_email}>),
			:bcc => %(<#{recipients}>),
			:from => %(<#{admin_email}>)
    }
  end
end
