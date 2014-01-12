class InitiativesController < ApplicationController
  before_filter :get_initiative, :only => [:edit, :show, :update, :destroy]
  before_filter :get_bucket_group, only: [:new_from_bucket_group, :create]
  # before_filter :authenticate_super_admin, :except => [:edit, :update, :show]
  before_filter :authenticate_user_for_initiative, :only => [:show]
  before_filter :authenticate_admin_for_initiative, :only => [:edit, :update]
  before_filter :get_initiative_from_subdomain, only: [:show, :edit, :update]
  before_filter :authenticate_admin_for_bucket_group, :only => [:new_from_bucket_group]
  before_filter :authenticate_bucket_line_creator, only: :create

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

    if params[:bucket_group_id].present?
      @bucket_group = BucketGroup.find(params[:bucket_group_id])
    end

    respond_to do |format|
      format.html do
        if @bucket_group.present?
          render "new_bucket_group"
        end
      end
      format.json { render json: @initiative }
    end
  end

  def new_from_bucket_group
    @initiative = Initiative.new
    @bucket_group = BucketGroup.find(params[:bucket_group_id])

    respond_to do |format|
      format.html do
        render "new_bucket_group"
      end
      format.json { render json: @initiative }
    end

  end

  # GET /initiatives/1/edit
  def edit
  end

  # POST /initiatives
  # POST /initiatives.json
  def create
    if params[:initiative][:bucket_group_id].present?
      bucket_group = BucketGroup.find(params[:initiative][:bucket_group_id])
      params[:initiative].delete(:bucket_group_id)
    end

    @initiative = Initiative.new(params[:initiative])

    respond_to do |format|
      if @initiative.save

        if bucket_group.present?
          bucket_group.users.each do |bu|
            @initiative.user_roles.create(user: bu.user)
          end
        end

        admin_user = @initiative.user_roles.find_or_create_by(:user_id => current_user.id) #Make the current user automatically admin of his newly created initiative
        admin_user.admin = true
        admin_user.save                                                                                           #
        format.html { redirect_to initiative_url(:subdomain => @initiative.slug), :notice => "Bucket Line is aangemaakt." }
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
      redirect_to edit_initiative_url(:subdomain => @initiative.slug), :notice => "Bucket Line is aangepast."
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

  private 

  def get_initiative_from_subdomain
    if request.subdomain
      @initiative = Initiative.where(slug: request.subdomain).first
    else
      @initiative = Initiative.find(params[:id])
    end
  end

  def get_bucket_group
    @bucket_group = nil
    if params[:bucket_group_id].present?
      @bucket_group = BucketGroup.find(params[:bucket_group_id]) 
    end
    if params[:initiative].present? and params[:initiative][:bucket_group_id].present?
      @bucket_group = BucketGroup.find(params[:initiative][:bucket_group_id]) 
    end
  end

end
