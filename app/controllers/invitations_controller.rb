class InvitationsController < ApplicationController
  before_filter :get_invitationable, :only => [:new, :create]
  # before_filter :authenticate_admin_for_initiative, :only => [:new, :create]

  #Make new invitation
  def new
    if @initiative.present?
      redirect_to login_url(:subdomain => false) unless current_user && (current_user.super_admin || current_user.user_roles.where(:initiative_id => @initiative.id).last)
      @invitation = Invitation.new(invitationable: @initiative)
      render "new"
    elsif @bucket_group.present?
      redirect_to login_url(:subdomain => false) unless current_user && (current_user.super_admin || @bucket_group.user_is_admin?(current_user) )
      @invitation = Invitation.new(invitationable: @bucket_group)
      render "new_bucket_group"
    else
    end
  end

  #Set password and register new user
  def accept
    @user = User.new
    @invitation = Invitation.where(:token => params[:token]).last

    if @invitation.nil?
      redirect_to root_path, :notice => "Token is ongeldig."
    else

      # @invitationable = @initiative.invitationable

      user = User.where(:email => @invitation.email).last

      if user.nil? #No user with the invited email exists yet, so set the password
        render :action => "accept" 
      else

        if @invitationable.is_a? Initiative
          @invitationable.user_roles.create(:user_id => user.id)
          @invitation.delete
        elsif @invitationable.is_a? BucketGroup
          @invitationable.users.build(user: user)
          @invitation.delete
        else
        end

        redirect_to login_path, :notice => "Uitnodiging is geaccepteerd, log in om verder te gaan."

      end
    end
  end

  #Send new invitation
  def create

    if User.where(email: params[:invitation][:email]).count > 0
      already_member = false
      user = User.where(email: params[:invitation][:email]).first
      if @initiative.present?
        unless @initiative.user_roles.where(user: user).count > 0
          @initiative.user_roles.create(user: user)
        else
          already_member = true
        end
      elsif @bucket_group.present?
        unless @bucket_group.users.where(user: user).count > 0
          @bucket_group.users.create(user: user)
        else
          already_member = true
        end
      else
      end

      respond_to do |format|
        format.html do
          if already_member
            flash[:notice] = "Gebruikers is al lid."            
          else
            flash[:notice] = "Gebruiker toegevoegd."
          end
          if @initiative.present?
            redirect_to root_path
          else
            redirect_to bucket_group_path(@bucket_group)
          end
        end
      end

    else

      if @initiative.present?
        @invitation = @initiative.invitations.new(params[:invitation])
      elsif @bucket_group.present?
        @invitation = @bucket_group.invitations.new(params[:invitation])
      else
      end

      respond_to do |format|
        if @invitation.save
          InvitationMailer.invitation_email(current_user.name, accept_invitation_url(:token => @invitation.token, :subdomain => false), @invitation.email).deliver
          format.html { redirect_to root_path, notice: 'Uitnodiging is verstuurd naar ' + @invitation.email.to_s }
        else
          format.html { redirect_to root_path, notice: "Er is iets fout gegaan... #{@invitation.errors.full_message}" }
       end
      end

    end

  end

  def register
    @invitation = Invitation.where(:token => params[:token]).last
    @user = User.new(params[:user])
    @user.skip_confirmation! #User got here by email, so confirmation is not necessary

    respond_to do |format|
      if @user.save

        if @invitation.invitationable.is_a? Initiative
          @user.user_roles.create(initiative: @invitation.invitationable)
          @invitation.delete
        elsif @invitation.invitationable.is_a? BucketGroup
          @invitation.invitationable.users.build(user: @user)
          @invitation.invitationable.save
        else
          format.html { redirect_to root_path, notice: 'Er is iets mis gegaan. Probeer later nog eens.' }
        end

        format.html { redirect_to login_path, notice: 'Registratie is voltooid, log in om verder te gaan.' }
      else
        format.html { render action: "accept" }
     end
    end

  end

  private

  def get_invitationable
    if request.subdomain.present?
      @invitationable = Initiative.where(slug: request.subdomain).first
      @initiative = @invitationable
    else
      @invitationable = BucketGroup.find(params[:bucket_group_id])
      @bucket_group = @invitationable
    end
  end

end
