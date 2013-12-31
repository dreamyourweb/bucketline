class UsersController < ApplicationController

  before_filter :authenticate_super_admin
 
  # GET /users
  # GET /users.json
  def index
   @users = User.all
   @user = User.new

   respond_to do |format|
     format.html # index.html.erb
     format.json  { render :json => @users }
   end
  end

  # GET /users/1
  # GET /users/1.json
  def show
   @user = User.find(params[:id])

   respond_to do |format|
     format.html # show.html.erb
     format.json  { render :json => @user }
   end
  end

  # GET /users/new
  # GET /users/new.json
  def new
   @user = User.new
   @current_method = "new"

   respond_to do |format|
     format.html # new.html.erb
     format.json  { render :json => @user }
   end
  end

  # GET /users/1/edit
  def edit
   @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create  
   @user = User.new(user_params)

   respond_to do |format|
     if @user.save
       format.html { redirect_to(admin_profiles_url(:subdomain => false), :notice => 'User was successfully created.') }
       format.json  { render :json => @user, :status => :created, :location => @user }
       format.js do
        flash[:notice] = 'User was successfully created.'
        @users = User.all
        @user = User.new
        render "update_index"
      end
     else
       format.html { render :action => "new" }
       format.json  { render :json => @user.errors, :status => :unprocessable_entity }
       format.js do
        flash[:alert] = 'User was not created.'
        @users = User.all
        @user = User.new
        render "update_index"
      end
     end
   end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
   @user = User.find(params[:id])

   respond_to do |format|
     if @user.update_attributes(user_params)
      flash[:notice] = 'User was successfully updated.'
       format.html { redirect_to :back }
       format.json  { head :ok }
       format.js do        
        @users = User.all
        render "update_index"
      end
     else
        flash[:alert] = 'User was not updated.'
       format.html { redirect_to :back }
       format.json  { render :json => @user.errors, :status => :unprocessable_entity }
       format.js do
        
        @users = User.all
        render "update_index"
      end
     end
   end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
   @user = User.find(params[:id])
   @user.destroy!

   respond_to do |format|
    @users = User.all
    @user = User.new
    format.html { redirect_to :back }
    format.js {flash[:notice] = 'Venue was successfully removed.'}
   end
  end

  private
 
  def user_params
    # params.require(:venue).permit(:name, :location, :description, :address => [:street, :city, :post_code], {:beer => []})
    params.require(:user).permit!
  end

end