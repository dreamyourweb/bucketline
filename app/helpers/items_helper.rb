module ItemsHelper
	def get_dayparts(item)
		dayparts = ""
		if !item.daypart.nil?
			dayparts = "; in de " + item.daypart.to_sentence
		end
		dayparts	
	end

	def get_contributors(item)
		contributores = ""
		profiles = item.profiles.where(:name.ne => "", :name.exists => true)
		if !profiles.empty?
			contributors = []
			profiles.each do |profile|
				contributors << profile.name
			end
			contributors = " Bijdragers zijn: " + contributors.to_sentence + "."
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
