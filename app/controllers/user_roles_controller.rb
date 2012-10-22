class UserRolesController < ApplicationController
  before_filter :authenticate_admin_for_initiative
  before_filter :authenticate_super_admin, :only => [:new, :create]

  before_filter :get_initiative

  # GET /user_roles
  # GET /user_roles.json
  #def index
  #  @user_roles = @initiative.user_roles.all

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render json: @user_roles }
  #  end
  #end

  # GET /user_roles/new
  # GET /user_roles/new.json
  def new
    @users = User.all
    @user_role = @initiative.user_roles.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_role }
    end
  end

  # GET /user_roles/1/edit
  #def edit
  #  @user_role = UserRole.find(params[:id])
  #end

  # POST /user_roles
  # POST /user_roles.json
  def create
    @user_role = @initiative.user_roles.new(params[:user_role])

    respond_to do |format|
      if @user_role.save
        format.html { redirect_to initiative_profiles_path(@initiative), notice: 'Gebruikersrol is aangepast.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /user_roles/1
  # PUT /user_roles/1.json
  def update
    @user_role = UserRole.find(params[:id])

    respond_to do |format|
      if @user_role.update_attributes(params[:user_role])
        if @user_role.user.profile.send_user_role_update_mail
          @user_role.send_user_role_update_mail
        end
        format.html { redirect_to initiative_profiles_path(@initiative), notice: 'Gebruikersrol is aangepast.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_roles/1
  # DELETE /user_roles/1.json
  def destroy
    @user_role = UserRole.find(params[:id])
    @user_role.destroy

    respond_to do |format|
      format.html { redirect_to :id => nil }
      format.json { head :no_content }
    end
  end
end
