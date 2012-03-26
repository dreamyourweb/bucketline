class Item
  include Mongoid::Document

	embedded_in :question
	#has_one :comment

	field :description
	field :provided, :type => Boolean, :default => false
	field :notes
	field :start_datetime, :type => DateTime 
	field :end_datetime, :type => DateTime
end
