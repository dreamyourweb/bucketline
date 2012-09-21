class ItemCancellationMailer < MailForm::Base
	attribute :item_name
	attribute :admin_contact
  attribute :admin_email
	attribute :recipients

  def headers
    {
      :subject => "Huis van Overvloed - Een item waaraan je bijdraagt is geannuleerd",
      :to => %(<#{admin_email}>),
			:bcc => %(<#{recipients}>),
			:from => %(<#{admin_email}>)
    }
  end
end
