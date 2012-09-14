class ReminderMailer < MailForm::Base
	attribute :item_names
	attribute :email

  def headers
    {
      :subject => "Bucketline - Herinnering: je bijdrage voor morgen",
      :to => %(<#{email}>),
      :from => "no-reply@bucketline.nl"
    }
  end
end
