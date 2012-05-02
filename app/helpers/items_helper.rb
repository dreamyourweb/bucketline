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
end
