class UserRole
	include Mongoid::Document
	include Mongoid::Timestamps

	#A user role is the role a user has for a particular initiative. User can be admin.
	belongs_to :user
	belongs_to :initiative

	field :admin, :type => Boolean, :default => false
end
