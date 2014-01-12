class InvitationBuddyMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']

  def invitation_email(inviter, invitation_url, email, name, patient_name)
    @inviter = inviter
    @invitation_url = invitation_url
    @email = email
    @name = name
    @patient_name = patient_name

    mail(:to => email, :subject => "Bucket Line - Nieuwe uitnodiging")
  end
end