module ItemsHelper
	def get_dayparts(item)
		dayparts = ""
		if !item.daypart.nil?
			dayparts = "; in de " + item.daypart.to_sentence
		end
		dayparts	
	end

	def get_contributors(item)
		contributors = []
		item.links.all.each do |link|
			contributors << link.profile.user.name
		end
		if !contributors.empty?
			contributors = " Bijdragers zijn: " + contributors.to_sentence + "."
		else
			contributors = ""
		end
		contributors
	end

	def get_icon(item)
		if item.type == 'help'
			"icon-user"
		elsif item.type == 'tool'
			"icon-cog"
		else
			"icon-home"
		end
	end
end
