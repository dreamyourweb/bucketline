class Profile
  include Mongoid::Document

	belongs_to :user
	has_many :available_dates, :autosave => true, :dependent => :delete	

	accepts_nested_attributes_for :available_dates, :allow_destroy => true

  field :name, :type => String
  field :expertise, :type => String
end
