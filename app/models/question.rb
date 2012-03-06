class Question
  	include Mongoid::Document
 	include Mongoid::Timestamps
	
	belongs_to :project
	has_many :comments, :dependent => :destroy
	has_many :items, :dependent => :destroy

	validates_presence_of :query
	validates_format_of :type, :with => /^help\z|^tool\z|^material\z/

	field :query
	field :type
end
