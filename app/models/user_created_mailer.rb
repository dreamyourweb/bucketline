class UserCreatedMailer < MailForm::Base
	attribute :user_email
	attribute :email

  def headers
    {
      :subject => "Bucket Line - Er is een nieuwe gebruiker aangemaakt",
      :to => %(<#{email}>),
      :from => "no-reply@bucketline.nl"
    }
  end
end
