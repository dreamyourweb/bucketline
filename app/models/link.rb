class Link
  include Mongoid::Document

	field :item_id
	field :profile_id
	field :amount

	before_save :consolidate_links

	def consolidate_links #add all duplicate links together
		@duplicate_link = Link.where(:item_id => self.item_id, :profile_id => self.profile_id).first
		if !@duplicate_link.nil?
			self.amount += @duplicate_link.amount
			@duplicate_link.delete
		end
	end
end
