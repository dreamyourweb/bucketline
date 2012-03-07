class Item
  include Mongoid::Document

	embedded_in :question

	field :description
	field :provided, :type => Boolean, :default => false
end
