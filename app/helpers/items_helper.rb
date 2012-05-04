module ItemsHelper
	def get_dayparts(item)
		dayparts = ""
		if !item.daypart.nil?
			dayparts = " in de "
			item.daypart.each do |daypart|
				if item.daypart.length == 1
					dayparts << daypart
				#elsif daypart == item.daypart
				#	dayparts << daypart
				elsif daypart == item.daypart.last(2).first
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
			contributors << " Bijdragers zijn "
			item.profiles.each do |profile|
				if item.profiles.length == 1
					contributors << profile.name
				elsif profile == item.profiles.first
					contributors << profile.name
				elsif profile == item.profiles.entries.last(2).first
					contributors << profile.name
				elsif profile == item.profiles.last
					contributors << " en " + profile.name
				else
					contributors << profile.name + ", "
				end
			end
		end
		contributors
	end
end
