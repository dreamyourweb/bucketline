class Link
  include Mongoid::Document
 	include Mongoid::Timestamps

	belongs_to :profile
	belongs_to :item

	validates_numericality_of :amount, :only_integer => true

	field :amount, :type => Integer
end
