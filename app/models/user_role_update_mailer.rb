class UserRoleUpdateMailer < MailForm::Base
  attribute :initiative
	attribute :email
  attribute :role

  def headers
    {
      :subject => "Bucket Line - Je bevoegdheden zijn aangepast",
      :to => email,
      :from => "no-reply@bucketline.nl"
    }
  end
end