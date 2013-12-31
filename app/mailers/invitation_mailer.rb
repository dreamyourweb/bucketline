class InvitationMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']

  def invitation_email(inviter, invitation_url, email)
    @inviter = inviter
    @invitation_url = invitation_url

    mail(:to => email, :subject => "Bucket Line - Nieuwe uitnodiging")
  end
end