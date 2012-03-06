class Item
  include Mongoid::Document

	belongs_to :question

	field :description
	field :provided?, :type => Boolean, :default => false
end
