class Item
  include Mongoid::Document

	belongs_to :question
end
