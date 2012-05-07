class ProfilesController < ApplicationController
	before_filter :authenticate_user!
	before_filter :authenticate_admin, :only => [:send_reminder_mail]

  # GET /profiles/1
  # GET /profiles/1.json
  def show
		@items = @profile.items.all.order_by([[:start_at, :asc]])
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
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
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
		@profile = Profile.find(params[:profile_id])
		@item = Item.find(params[:id])
		if @profile == current_user.profile
			@profile.remove_item(@item)
			@item.remove_profile(@profile)
			redirect_to profile_path(@profile), :notice => "Bijdrage is ingetrokken."
		else
			redirect_to profile_path(@profile), :notice => "Je kunt alleen je eigen bijdrages intrekken."
		end
	end

	def send_reminder_mail #sends a reminder to all the users who will contribute tomorrow
		@profile = current_user.profile
		User.all.each do |user|
			if user.profile.send_reminder_mail
				item_names = []
				items = user.profile.items.where(:start_at => Date.tomorrow).entries
				items.each do |item|
					item_names << item.name	
				end
				if !item_names.empty?
					email = ReminderMailer.new(:item_names => item_names.to_sentence, :email => user.email)
					email.deliver
				end
			end
		end
		redirect_to profile_availability_dashboard_path(current_user.profile), :notice => "Herinneringen zijn gestuurd."
	end

	def info
		render :layout => false
	end
end
