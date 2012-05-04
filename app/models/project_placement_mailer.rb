class ProjectPlacementMailer < MailForm::Base
	attribute :project_query
	attribute :project_start_at
	attribute :project_end_at
	attribute :project_dayparts
	attribute :email

  def headers
    {
      :subject => "Er is een project aangemaakt op een datum dat je beschikbaar bent",
      :to => %(<#{email}>),
      :from => "thijsvdlaar@hotmail.com"
    }
  end
end
