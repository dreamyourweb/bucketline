class Question
  include Mongoid::Document

	belongs_to :project
	embeds_many :comments
	embeds_many :items
end
