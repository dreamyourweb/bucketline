class ItemRetreatContributionMailer < MailForm::Base
  attribute :initiative
	attribute :project_query
  attribute :project_date
	attribute :item_name
	attribute :amount
  attribute :contributor_name
  attribute :contributor_email
	attribute :admin_email

  def headers
    {
      :subject => "Bucket Line - Een bijdrage aan een van je klussen of benodigdheden is ingetrokken",
      :to => admin_email,
      :from => "no-reply@bucketline.nl"
    }
  end
end
