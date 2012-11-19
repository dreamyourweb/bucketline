class InvitationsController < Devise::InvitationsController

  #Pasted entire controller in here, but should actually overwrite only the things that are necessary

  before_filter :get_initiative, :only => [:new, :create]  
  before_filter :authenticate_inviter!, :only => [:new, :create]
  before_filter :has_invitations_left?, :only => [:create]
  before_filter :require_no_authentication, :only => [:edit, :update]
  helper_method :after_sign_in_path_for

  # GET /resource/invitation/new
  def new
    build_resource
    render :new
  end

  # POST /resource/invitation
  def create
    user = User.where(resource_params).first
    if user.nil?
      user = User.invite!(resource_params.merge({:last_invited_for_initiative_id => @initiative.id}), current_inviter)
    else
      user.invite!
      user.update_attributes(:last_invited_for_initiative_id => @initiative.id)
    end

    if user.errors.empty?
      set_flash_message :notice, :send_instructions, :email => user.email
      respond_with user, :location => after_invite_path_for(user)
    else
      respond_with_navigational(user) { render :new }
    end
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    @user = User.to_adapter.find_first( :invitation_token => params[:invitation_token] ) #Find user with correct token
    initiative = Initiative.find(@user.last_invited_for_initiative_id)
    if @user.invitation_accepted_at && initiative #User is already registered, so no new login has to be created
      UserRole.create(:initiative_id => initiative.id, :user_id => @user.id)
      redirect_to login_path, :notice => "Je bent nu aangemeld bij je nieuwe Bucket Line, log in om verder te gaan."
    elsif params[:invitation_token] && @user && initiative
      UserRole.create(:initiative_id => initiative.id, :user_id => @user.id)
      render :edit #Set the name and password
    else
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to after_sign_out_path_for(user)
    end
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(resource_params)

    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

  protected
  def current_inviter
    @current_inviter ||= authenticate_inviter!
  end

  def has_invitations_left?
    unless current_inviter.nil? || current_inviter.has_invitations_left?
      build_resource
      set_flash_message :alert, :no_invitations_remaining
      respond_with_navigational(resource) { render :new }
    end
  end

end