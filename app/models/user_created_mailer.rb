class UserCreatedMailer < MailForm::Base
	attribute :user_email
	attribute :email

  def headers
    {
      :subject => "Huis van Overvloed - Er is een nieuwe gebruiker aangemaakt",
      :to => %(<#{email}>),
      :from => "no-reply@waardeverbinder.nl"
    }
  end
end
