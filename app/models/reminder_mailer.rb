class ReminderMailer < MailForm::Base
	attribute :initiative_names
	attribute :project_names
	attribute :item_names
	attribute :email

  def headers
    {
      :subject => "Bucket Line - Herinnering: je bijdrage voor morgen",
      :to => email,
      :from => "no-reply@bucketline.nl"
    }
  end
end
