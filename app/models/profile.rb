class Profile
  include Mongoid::Document
	include Mongoid::MultiParameterAttributes

	embedded_in :user

  field :name, :type => String
  field :expertise, :type => String
	field :availability, :type => DateTime
end
