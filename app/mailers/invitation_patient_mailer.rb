class InvitationPatientMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']

  def invitation_email(inviter, invitation_url, email, name, buddy_name)
    @inviter = inviter
    @invitation_url = invitation_url
    @email = email
    @name = name
    @buddy_name = buddy_name

    mail(:to => email, :subject => "Bucket Line - Nieuwe uitnodiging")
  end
end