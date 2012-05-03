class Profile
  include Mongoid::Document

	belongs_to :user
	has_many :available_dates, :autosave => true, :dependent => :delete
	has_and_belongs_to_many :items, :dependent => :nullify #All the items that have been contributed by this user	

	accepts_nested_attributes_for :available_dates, :allow_destroy => true

  field :name, :type => String
  field :expertise, :type => String
  field :willing_to_help_with, :type => String
  field :tools_and_materials, :type => String

	def link_to_item(amount, item)
		amount.times do
			self.items << item
		end
	end
end
