class ItemPlacementMailer < MailForm::Base
	attribute :item_sentence
	attribute :recipients

  	def headers
	    {
		    :subject => "Huis van Overvloed - Er zijn nieuwe benodigdheden geplaatst",
		    :to => "no-reply@waardeverbinder.nl",
			:bcc => %(<#{recipients}>),
			:from => "no-reply@waardeverbinder.nl"
	    }
  	end
end
