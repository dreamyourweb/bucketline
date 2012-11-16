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
		anonymous_contributor_count = 0
		item.links.all.each do |link|
			if link.profile.show_name_in_overview
				contributors << link.profile.user.name
			else
				anonymous_contributor_count += 1
			end
		end
		if !contributors.empty?
			contributors = " Bijdragers zijn: " + contributors.to_sentence
			if anonymous_contributor_count > 0
				contributors << ", en nog " + anonymous_contributor_count.to_s + " ander(en)"
			end
			contributors << "."
		else
			contributors = ""
			if anonymous_contributor_count > 0
				contributors << anonymous_contributor_count.to_s + " bijdrager(s)."
			end
		end
		contributors
	end

	def get_icon(item)
		if item.type == 'in en om het huis'
			"icon-home"
		elsif item.type == 'oppas en gezelschap'
			"icon-user"
		elsif item.type == 'vervoer'
			"icon-road"
		elsif item.type == 'boodschappen en koken'
			"icon-shopping-cart"
		else
			"icon-home"
		end
	end
end
