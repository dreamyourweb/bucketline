module ProfilesHelper
	def get_amount(profile, item)
		Link.where(:profile_id => profile.id, :item_id => item.id).first.amount
	end

	def build_emails_for_copy(users)
		list = ""
		users.each do |user|
			if user == users.first
				list << user.email
			else
				list << ", " + user.email
			end
		end
		list
	end
end
