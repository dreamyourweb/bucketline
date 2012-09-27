class Initiative
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :location, :type => String
  field :description, :type => String

  has_many :user_roles, :dependent => :destroy #Roles for an initiative such as admin or superadmin are tracked via the userrole model

	has_many :projects, :dependent => :destroy
	has_many :items, :dependent => :destroy #loose items

	def admins
		user_roles = UserRole.where(:initiative_id => self.id, :admin => true)
		admins = []
		user_roles.each do |user_role|
			admins << user_role.user
		end
		admins
	end

end
