class BucketGroupsController < ApplicationController
  before_filter :get_bucket_group, only: [:show, :settings, :edit, :admin_edit, :update]
  before_filter :authenticate_super_admin, :only => [:index, :new]
  before_filter :authenticate_user_for_bucket_group, except: [:new_unregistered, :create]
  before_filter :authenticate_admin_for_bucket_group, except: [:show, :new_unregistered, :create]

  def index
    @bucket_groups = BucketGroup.all
  end

  def new
    @bucket_group = BucketGroup.new
  end

  def new_unregistered
    @bucket_group = BucketGroup.new
  end

  def edit
    # @bucket_group = BucketGroup.find(params[:id])
  end

  def admin_edit
    # @bucket_group = BucketGroup.find(params[:id])
  end

  def show
  end

  def settings
  end

  def create
    @bucket_group = BucketGroup.new(params[:bucket_group])

    if params[:bucket_group][:new_registration]
      user = User.new( email: params[:bucket_group][:creator_email],
                          name: params[:bucket_group][:creator_name],
                          password: params[:bucket_group][:creator_password],
                          password_confirmation: params[:bucket_group][:creator_password_confirmation] 
        )
      if @bucket_group.valid?
        user.save
      end
    else
      user = current_user
    end

    @bucket_group.errors[:creator_name] = user.errors[:name]
    @bucket_group.errors[:creator_email] = user.errors[:email]
    @bucket_group.errors[:creator_password] = user.errors[:password]
    @bucket_group.errors[:creator_password_confirmation] = user.errors[:password_confirmation]

    respond_to do |format|
      if !(user.errors.count > 0) and @bucket_group.save
        @bucket_group.users.create(:user_id => user.id, :admin => true)
        format.html do
          if current_user.present?
            redirect_to admin_bucket_groups_url(:subdomain => false), :notice => "Preventieve Bucket Line is aangemaakt."
          else
            redirect_to root_path, notice: "Je nieuwe preventieve Bucket Line is aangemaakt. Een bericht met een bevestigingslink is verstuurd naar je e-mail adres. Klik op deze link om je aanmelding te bevestigen."
          end
        end
      else
        
        format.html do
          if current_user.present?
            render action: "new"
          else
            render action: "new_unregistered"
          end
        end
        format.json { render json: @bucket_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # @bucket_group = BucketGroup.find(params[:id])

    respond_to do |format|
      if @bucket_group.update_attributes(params[:bucket_group])
        format.html {render action: :show, notice: "Preventieve Bucket Line geupdatet"}
      else
        format.html {render action: :show, alert: "Preventieve Bucket Line niet geupdatet."}
      end
    end
  end

  def destroy
    BucketGroup.find(params[:id]).destroy
    respond_to do |format|
      format.html {redirect_to :back, notice: "Preventieve Bucket Line verwijderd."}
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
