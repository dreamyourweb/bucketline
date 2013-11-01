class BucketGroup
  include Mongoid::Document
  include Mongoid::Timestamps

  before_save :build_slug

  field :name, type: String
  field :description, type: String
  field :slug, type: String

  embeds_many :users, class_name: "BucketGroupUser", cascade_callbacks: true
  has_many :invitations, :dependent => :destroy, as: :invitationable

  accepts_nested_attributes_for :users

  validates_presence_of :name
  validates_uniqueness_of :name, :slug

  private

  def build_slug
    self.slug = self.name.parameterize
  end
  
end
