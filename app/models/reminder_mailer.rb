class ReminderMailer < MailForm::Base
	attribute :item_names
	attribute :email
	attribute :sender

  def headers
    {
      :subject => "Huis van Overvloed - Je bijdrage voor morgen",
      :to => %(<#{email}>),
      :from => "no-reply@waardeverbinder.nl"
    }
  end
end
