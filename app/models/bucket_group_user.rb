class BucketGroupUser
  include Mongoid::Document

  belongs_to :user
  embedded_in :bucket_group

  field :admin, type: Mongoid::Boolean, default: false

  validates_uniqueness_of :user
end
