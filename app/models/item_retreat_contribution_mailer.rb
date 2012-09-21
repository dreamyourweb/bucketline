class ItemRetreatContributionMailer < MailForm::Base
	attribute :project_query
	attribute :item_name
	attribute :amount
  attribute :contributor_name
  attribute :contributor_email
	attribute :admin_email

  def headers
    {
      :subject => "Huis van Overvloed - Een bijdrage aan een van je projecten is ingetrokken",
      :to => %(<#{admin_email}>),
      :from => "no-reply@waardeverbinder.nl"
    }
  end
end
