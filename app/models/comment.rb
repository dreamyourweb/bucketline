class Comment
  include Mongoid::Document

	embedded_in :question

	field :author
	field :body
end
