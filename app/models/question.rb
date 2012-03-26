class Question
  include Mongoid::Document
 	include Mongoid::Timestamps
	
	embeds_many :comments
	embeds_many :items
	
	accepts_nested_attributes_for :items, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

	validates_presence_of :query
	validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

	field :query
	field :type
	field :location

	def get_question_comments
		self.comments.all.order_by(:updated_at, :desc).entries
	end
end
