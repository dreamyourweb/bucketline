class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, :type => String
  field :email, :type => String

  belongs_to :initiative

  before_create :set_token

  validate :email_not_in_use, :message => "Email is al in gebruik."

  def email_not_in_use
    user = User.where(:email => self.email)
    user.nil? || user.empty?
  end

  protected

  def set_token
    begin
      token = SecureRandom.urlsafe_base64
    end while Invitation.where(:token => token).exists?
    self.token = token
  end
end
