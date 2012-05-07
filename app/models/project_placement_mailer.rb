class ProjectPlacementMailer < MailForm::Base
	attribute :project_query
	attribute :project_start_at
	attribute :project_end_at
	attribute :project_dayparts
	attribute :email

  def headers
    {
      :subject => "Huis van Overvloed - Er is een project aangemaakt op een datum dat je beschikbaar bent",
      :to => %(<#{email}>),
      :from => "no-reply@waardeverbinder.nl"
    }
  end
end
