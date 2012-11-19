class InvitationMailer < MailForm::Base
  attribute :inviter
  attribute :invitation_url
	attribute :email

  def headers
    {
      :subject => "Bucket Line - Nieuwe uitnodiging",
      :to => email,
      :from => "no-reply@bucketline.nl"
    }
  end
end