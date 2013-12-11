class AuthenticationsController < ApplicationController
	def create
		auth = request.env["omniauth.auth"]
	 
		# Try to find authentication first
		authentication = Authentication.where(:provider => auth['provider'], :uid => auth['uid']).first
	 
		if authentication.nil?
		  # Authentication not found
			if User.where(:email => auth['extra']['raw_info']['email']).empty? #Email is not registered yet
			  user = User.new
				user.apply_omniauth(auth)
				if user.save(:validate => false)
				  flash[:notice] = "Er is een login aangemaakt via facebook."
				  sign_in_and_redirect(:user, user)
				else
				  flash[:error] = "Er ging iets mis bij het aanmaken van je registratie. Probeer het nog eens."
				  redirect_to root_url
				end
			else #User is already registered via normal route
				flash[:error] = "Je emailadres is al geregistreerd, log in met je email en wachtwoord."
				redirect_to login_url
			end
		else
		  # Authentication found, sign the user in.
		  flash[:notice] = "Je bent succesvol ingelogd via je facebook account."
		  sign_in_and_redirect(:user, authentication.user)
		end
	end
end
