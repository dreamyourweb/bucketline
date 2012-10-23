class ItemPlacementMailer < MailForm::Base
  attribute :initiative
	attribute :item_sentence
	attribute :recipients

  	def headers
	    {
		    :subject => "Bucket Line - Er zijn nieuwe benodigdheden geplaatst",
		    :to => "no-reply@bucketline.nl",
			:bcc => recipients,
			:from => "no-reply@bucketline.nl"
	    }
  	end
end
