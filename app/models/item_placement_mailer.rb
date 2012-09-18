class ItemPlacementMailer < MailForm::Base
	attribute :item_name
	attribute :item_description
	attribute :admin_email
	attribute :admin_contact
	attribute :recipients

  	def headers
	    {
		    :subject => "Huis van Overvloed - Er is een nieuwe benodigdheid geplaatst",
		    :to => %(<#{admin_email}>),
			:bcc => %(<#{recipients}>),
			:from => %(<#{admin_email}>)
	    }
  	end
end
