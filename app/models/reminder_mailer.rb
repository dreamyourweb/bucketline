class ReminderMailer < MailForm::Base
	attribute :item_names
	attribute :email

  def headers
    {
      :subject => "Huis van Overvloed - Herinnering: je bijdrage voor morgen",
      :to => %(<#{email}>),
      :from => "no-reply@waardeverbinder.nl"
    }
  end
end
