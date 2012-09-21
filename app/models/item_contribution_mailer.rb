class ItemContributionMailer < MailForm::Base
	attribute :project_query
	attribute :item_name
	attribute :amount
  attribute :contributor_name
  attribute :contributor_email
	attribute :admin_email

  def headers
    {
      :subject => "Huis van Overvloed - Er is een nieuwe bijdrage aan een van je projecten of benodigdheden",
      :to => %(<#{admin_email}>),
      :from => "no-reply@waardeverbinder.nl"
    }
  end
end
