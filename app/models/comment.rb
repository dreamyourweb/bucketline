class Comment
  include Mongoid::Document

	embedded_in :question

	validates_presence_of :body

	field :author
	field :body
end
