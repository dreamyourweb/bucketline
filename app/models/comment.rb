class Comment
  include Mongoid::Document

	belongs_to :question
end
