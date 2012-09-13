class ProfilesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :authenticate_admin, :only => [:index]
	before_filter :get_initiative

	def index
		@users = User.all.entries
	end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
		@items = []
		@profile = current_user.profile
		@profile.links.all.each do |link| 
			@items << link.item
		end
		#items.order_by([[:start_at, :asc]])
		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    current_user.profile = Profile.new
		@profile = current_user.profile

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = current_user.profile
  end

  # POST /profiles
  # POST /profiles.json
  def create
    current_user.profile = Profile.new(params[:profile])
		@profile = current_user.profile

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render json: @profile, status: :created, location: @profile }
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = current_user.profile

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to @profile, notice: 'Je profiel is bijgewerkt.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = current_user.profile
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

	def remove_item
		@link = Link.where(:profile_id => params[:profile_id], :item_id => params[:id]).first
		if params[:redirect_to_links]
			@link.destroy
			redirect_to links_path, :notice => "Bijdrage is ingetrokken."
		elsif @profile == current_user.profile
			@link.destroy
			redirect_to profile_path(@profile), :notice => "Bijdrage is ingetrokken."
		else
			redirect_to profile_path(@profile), :notice => "Je kunt alleen je eigen bijdrages intrekken."
		end
	end

	def info
		render :layout => false
	end
end
