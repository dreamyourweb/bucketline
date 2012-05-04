module ItemsHelper
	def get_dayparts(item)
		dayparts = ""
		if !item.daypart.nil?
			dayparts = " in de "
			item.daypart.each do |daypart|
				if daypart == item.daypart
						dayparts << daypart
				elsif daypart == item.daypart.last
						dayparts << " en " + daypart
				else
						dayparts << daypart + ", "
				end
			end
		end
		dayparts	
	end

	def get_contributors(item)
		contributors = ""
		if !item.profiles.empty?
			contributors << " Bijdragers zijn"
			item.profiles.each do |profile|
				contributors << ", " + profile.name 
			end
			contributors << "."
		end
		contributors
	end
end
