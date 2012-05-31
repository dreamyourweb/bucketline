class Message
  include Mongoid::Document
 	include Mongoid::Timestamps

	validates_presence_of :body

  field :sender, :type => String
  field :body, :type => String
end
