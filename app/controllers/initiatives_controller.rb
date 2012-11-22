class InitiativesController < ApplicationController
  before_filter :get_initiative, :only => [:edit, :show, :update]
  before_filter :authenticate_super_admin, :except => [:edit, :update, :show]
  before_filter :authenticate_user_for_initiative, :only => [:show]
  before_filter :authenticate_admin_for_initiative, :only => [:edit, :update]

  # GET /initiatives
  # GET /initiatives.json
  def index
    @initiatives = Initiative.all
  end

  # GET /initiatives/1
  # GET /initiatives/1.json
  def show
    @user_role = @initiative.user_roles.where(:user_id => current_user.id).last

    @admin_names = []
    @user_names = []
    @extra_user_count = 0

    @initiative.user_roles.each do |user_role|
      if user_role.admin && user_role.user.profile.show_name_in_overview
        @admin_names << user_role.user.name
      elsif user_role.user.profile.show_name_in_overview
        @user_names << user_role.user.name
      else
        @extra_user_count += 1
      end
    end
  end

  # GET /initiatives/new
  # GET /initiatives/new.json
  def new
    @initiative = Initiative.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @initiative }
    end
  end

  # GET /initiatives/1/edit
  def edit
  end

  # POST /initiatives
  # POST /initiatives.json
  def create
    @initiative = Initiative.new(params[:initiative])

    respond_to do |format|
      if @initiative.save
        @initiative.user_roles.create(:user_id => current_user.id, :admin => true) #Make the current user automatically admin of his newly created initiative
        format.html { redirect_to admin_initiatives_url + "?no_redirect=true", :notice => "Bucket Line is aangemaakt." }
      else
        format.html { render action: "new" }
        format.json { render json: @initiative.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /initiatives/1
  # PUT /initiatives/1.json
  def update
    #@initiative = Initiative.find(params[:id])
    if @initiative.update_attributes(params[:initiative])
      redirect_to settings_url(:subdomain => @initiative.slug), :notice => "Bucket Line is aangepast."
    else
      render action: "edit"
    end
  end

  # DELETE /initiatives/1
  # DELETE /initiatives/1.json
  def destroy
    @initiative = Initiative.where(slug: request.subdomain).first
    @initiative.destroy

    respond_to do |format|
      format.html { redirect_to admin_initiatives_url + "?no_redirect=true" }
      format.json { head :no_content }
    end
  end
end
