class ItemContributionMailer < MailForm::Base
	attribute :project_query
  attribute :project_date
	attribute :item_name
	attribute :amount
  attribute :contributor_name
  attribute :contributor_email
	attribute :admin_email

  def headers
    {
      :subject => "Bucket Line - Er is een nieuwe bijdrage aan een van je projecten of benodigdheden",
      :to => %(<#{admin_email}>),
      :from => "no-reply@bucketline.nl"
    }
  end
end
