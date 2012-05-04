class ProjectPlacementMailer < MailForm::Base
	attribute :item_names
	attribute :email

  def headers
    {
      :subject => "Voor morgen heb je de volgende bijdragen toegezegd",
      :to => %(<#{email}>),
      :from => "thijsvdlaar@hotmail.com"
    }
  end
end
