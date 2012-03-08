class HelpMailer < MailForm::Base
	attribute :question_type
	attribute :question
	attribute :item_description
	attribute :author
	attribute :comment_body
	attribute :comment_info

  def headers
    {
      :subject => "Iemand heeft aangegeven om iets bij te dragen",
      :to => "thijsvdlaar@hotmail.com",
      :from => "thijsvdlaar@hotmail.com"
    }
  end
end
