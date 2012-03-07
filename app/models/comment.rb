class Comment
  include Mongoid::Document
	include Mongoid::Timestamps

	embedded_in :question

	validates_presence_of :body

	field :author
	field :body
	field :info
end
