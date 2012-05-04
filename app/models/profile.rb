class Profile
  include Mongoid::Document

	belongs_to :user
	has_many :available_dates, :autosave => true, :dependent => :destroy
	has_and_belongs_to_many :items, :dependent => :nullify #All the items that have been contributed by this user	

	accepts_nested_attributes_for :available_dates, :allow_destroy => true

  field :name, :type => String
  field :expertise, :type => String
  field :willing_to_help_with, :type => String
  field :tools_and_materials, :type => String
	field :send_reminder_mail, :type => Boolean, :default => true
	field :send_project_placement_mail, :type => Boolean, :default => true

	def link_to_item(amount, item)
		self.items << item
	end

	def remove_item(amount, item)
		self.items.delete(item)
	end
end
