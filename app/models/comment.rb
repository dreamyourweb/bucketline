class Comment
  include Mongoid::Document
	include Mongoid::Timestamps

	embedded_in :question

	validates_presence_of :body

	field :author
	field :body
	field :info
	field :belongs_to_item_id #Een reactie kan ook gerelateerd zijn aan een item, als dit item geleverd wordt. Om mee te mailen over welk item de reactie gaat is het goed om dit even op te slaan.
end
