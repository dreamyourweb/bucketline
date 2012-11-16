class Profile
  include Mongoid::Document
 	include Mongoid::Timestamps

	belongs_to :user
	has_many :available_dates, :autosave => true, :dependent => :destroy
	has_many :links, :dependent => :destroy #All the items that have been contributed by this user	

	accepts_nested_attributes_for :available_dates, :allow_destroy => true

  field :phone, :type => String, :default => ""
  field :expertise, :type => String
  field :willing_to_help_with, :type => String
  field :tools_and_materials, :type => String
  field :willing_to_become_admin, :type => Boolean, :default => false
	field :show_name_in_overview, :type => Boolean, :default => true
	field :send_reminder_mail, :type => Boolean, :default => true
	field :send_project_cancellation_mail, :type => Boolean, :default => true
	field :always_send_project_placement_mail, :type => Boolean, :default => true
	field :send_user_role_update_mail, :type => Boolean, :default => true
end
