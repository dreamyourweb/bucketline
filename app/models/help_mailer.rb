class HelpMailer < MailForm::Base
	attribute :project
	attribute :item
	attribute :number

  def headers
    {
      :subject => "Iemand heeft aangegeven om iets bij te dragen",
      :to => "thijsvdlaar@hotmail.com",
      :from => "thijsvdlaar@hotmail.com"
    }
  end
end
