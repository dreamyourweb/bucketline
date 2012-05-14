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

	def get_item_color_class(item)
		class_name = ""
		if user_signed_in? && item.profile_ids.include?(current_user.profile.id)
			class_name = "providing"
		end
		class_name
	end

	def get_contributors(item)
		contributors = ""
		profiles = item.profiles.where(:name.ne => "", :name.exists => true)
		if !profiles.empty?
			contributors << " Bijdragers zijn: "
			profiles.each do |profile|
				if profiles.length == 1
					contributors << profile.name
				elsif profile == profiles.first
					contributors << profile.name
				elsif profile == profiles.entries.last(2).first
					contributors << profile.name
				elsif profile == profiles.last
					contributors << " en " + profile.name
				else
					contributors << profile.name + ", "
				end
			end
			contributors << "."
		end
		contributors
	end
end
