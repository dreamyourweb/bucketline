class Question
  include Mongoid::Document

	belongs_to :project
	embeds_many :comments
	embeds_many :items

	validates_presence_of :query
	validates_format_of :type, :with => /help|tool|material/

	field :query
	field :type
end
