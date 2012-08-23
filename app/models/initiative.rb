class Initiative
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :location, :type => String
  field :description, :type => String

	has_many :projects
end
