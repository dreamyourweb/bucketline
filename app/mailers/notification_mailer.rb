class NotificationMailer < ActionMailer::Base
  default :from => ENV['EMAIL_SENDER']

  def project_placement_mail(initiative, projects, mailing_list)
  	@initiative = initiative
  	@projects = projects

    mail(:to => ENV['EMAIL_SENDER'], :bcc => mailing_list, :subject => "Bucket Line - Er zijn nieuwe klussen geplaatst voor <%= @initiative.name %>")
  end
end