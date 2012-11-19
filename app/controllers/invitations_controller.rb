class InvitationsController < ApplicationController
  before_filter :get_initiative, :only => [:new, :create]
  before_filter :authenticate_admin_for_initiative, :only => [:new, :create]

  #Make new invitation
  def new
    @invitation = Invitation.new
  end

  #Set password and register new user
  def accept
    @user = User.new
    @invitation = Invitation.where(:token => params[:token]).last
    if @invitation.nil?
      redirect_to root_path, :notice => "Token is ongeldig."
    else
      @initiative = @invitation.initiative
      user = User.where(:email => @invitation.email).last
      if user.nil? #No user with the invited email exists yet, so set the password
        render :action => "accept" 
      else
        #Just create user_role for the existing user
        @initiative.user_roles.create(:user_id => user.id)
        @invitation.delete
        redirect_to login_path, :notice => "Uitnodiging is geaccepteerd, log in om verder te gaan."
      end
    end
  end

  #Send new invitation
  def create
    @invitation = @initiative.invitations.new(params[:invitation])

    respond_to do |format|
      if @invitation.save
        email = InvitationMailer.new(:inviter => current_user.name, :invitation_url => accept_invitation_url(:token => @invitation.token, :subdomain => false), :email => @invitation.email)
        email.deliver
        format.html { redirect_to profiles_path, notice: 'Uitnodiging is verstuurd naar ' + @invitation.email.to_s }
      else
        format.html { render action: "new" }
     end
    end
  end

  def register
    @invitation = Invitation.where(:token => params[:token]).last
    @user = User.new(params[:user])
    @user.skip_confirmation! #User got here by email, so confirmation is not necessary

    respond_to do |format|
      if @user.save
        @user.user_roles.create(:initiative_id => @invitation.initiative_id)
        @invitation.delete
        format.html { redirect_to login_path, notice: 'Registratie is voltooid, log in om verder te gaan.' }
      else
        format.html { render action: "accept" }
     end
    end

  end
end
