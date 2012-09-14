class HelpMailer < MailForm::Base
	attribute :project
	attribute :item
	attribute :number

  def headers
    {
      :subject => "Iemand heeft aangegeven om iets bij te dragen",
      :to => "thijs@dreamyourweb.nl",
      :from => "no-reply@bucketline.nl"
    }
  end
end
