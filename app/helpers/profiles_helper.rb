module ProfilesHelper
	def get_amount(profile, item)
		Link.where(:profile_id => profile.id, :item_id => item.id).first.amount
	end
end
