class BucketGroupsController < ApplicationController
  before_filter :authenticate_super_admin, :only => [:index]
  before_filter :authenticate_user_for_initiative
  before_filter :authenticate_admin_for_initiative, except: [:show]


  def index
    @bucket_groups = BucketGroup.all
  end

  def new
    @bucket_group = BucketGroup.new
  end

  def edit
    @bucket_group = BucketGroup.find(params[:id])
  end

  def admin_edit
    @bucket_group = BucketGroup.find(params[:id])
  end

  def show
    get_bucket_group
  end

  def settings
    get_bucket_group
  end

  def create
    @bucket_group = BucketGroup.new(params[:bucket_group])

    respond_to do |format|
      if @bucket_group.save
        @bucket_group.users.create(:user_id => current_user.id, :admin => true)
        format.html { redirect_to admin_bucket_groups_url(:subdomain => false), :notice => "Bucket groep is aangemaakt." }
      else
        format.html { render action: "new" }
        format.json { render json: @bucket_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @bucket_group = BucketGroup.find(params[:id])

    respond_to do |format|
      if @bucket_group.update_attributes(params[:bucket_group])
        format.html {render action: :show, notice: "Bucket groep geupdatet"}
      else
        format.html {render action: :show, alert: "Bucket groep niet geupdatet."}
      end
    end
  end

  def destroy
    BucketGroup.find(params[:id]).destroy
    respond_to do |format|
      format.html {redirect_to :back, notice: "Bucker groep verwijderd."}
    end
  end

  private

  def get_bucket_group
    @bucket_group = if BucketGroup.where(_id: params[:id]).exists?
      BucketGroup.find(params[:id]) 
    else
      BucketGroup.find_by(slug: params[:id])
    end
  end

end
