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
  # validates_format_of :creator_email, with: /\A(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Z‌​a-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}\z/i, message: "Geen geldig e-mail adres"

  attr_accessor :creator_email, :creator_password, :creator_password_confirmation, :creator_name

  def user_is_member?(user)
    self.users.where(user_id: user.id).present?
  end

  def user_is_admin?(user)
    self.users.where(user_id: user.id).present? and self.users.where(user_id: user.id).first.admin
  end

  private

  def build_slug
    self.slug = self.name.parameterize
  end
  
end
