class AvailableDate
  include Mongoid::Document
 	include Mongoid::Timestamps
	include Mongoid::MultiParameterAttributes

	belongs_to :profile

  field :start_at, :type => DateTime
  field :end_at, :type => DateTime
end
