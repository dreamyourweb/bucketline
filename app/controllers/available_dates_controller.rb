class AvailableDatesController < ApplicationController
  before_filter :get_initiative
	before_filter :authenticate_user_for_initiative, :get_profile
	before_filter :authenticate_admin_for_initiative, :only => [:availability_dashboard]
	before_filter :set_calendar, :only => [:index, :availability_dashboard]
	
	def get_profile
		@profile = current_user.profile
	end

  def availability_dashboard
    #Only show available dates of users that are available for the current initiative
    @available_dates = []
    @initiative.user_roles.each do |user_role|
      if params[:show] == "all"
        user_role.user.profile.available_dates.each do |available_date|
          if available_date
            @available_dates << available_date
          end
        end
      else
        user_role.user.profile.available_dates.where(:date.gte => Date.today).each do |available_date|
          if available_date
            @available_dates << available_date
          end
        end
      end
    end

    @dates = []
    @available_dates.each do |available_date|
      @dates << available_date.date
    end
    @dates = @dates.uniq

    respond_to do |format|
      format.html
      format.json { render json: @available_dates }
    end
  end

  def set_calendar

    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @current_month = Date.civil(@year, @month)
    @first_day_month = Date.civil(@year, @month)
    @last_day_month = Date.civil(@year, @month, -1)

		@first_day_of_week = 1

    @available_dates_hash = Array.new

    @available_dates = @profile.available_dates.where(:date.gte => @first_day_month, :date.lte => @last_day_month).asc(:date).each do |e|
      @available_dates_hash[e.start_at.day] = [] if @available_dates_hash[e.start_at.day].nil?;
      @available_dates_hash[e.start_at.day].push(e)
    end

	end

  def index
    @available_dates = @profile.available_dates.all
		# @event_strips = current_user.profile.available_dates.all.event_strips_for_month(@shown_month, @first_day_of_week)

		respond_to do |format|
      format.html
      format.json { render json: @available_dates }
		end
  end

	def edit
		@available_date = AvailableDate.find(params[:id])
		#@profile = Profile.find(params[:profile_id])
		#@user = @profile.user
		render :layout => false
	end

	def new
    double_date = AvailableDate.where(:profile_id => current_user.profile.id, :date => Date.parse(params[:date])).first
    if double_date
      redirect_to edit_profile_available_date_path(current_user.profile, double_date)
    else
      @available_date = @profile.available_dates.new
  		render :layout => false
    end
	end

  def create
    @available_date = @profile.available_dates.new(params[:available_date])

    respond_to do |format|
      if @available_date.save
        format.html { redirect_to profile_available_dates_path(@profile), notice: 'Beschikbaarheid is aangepast.' }
        format.json { render json: @available_date, status: :created, location: @available_date }
      else
        format.html { render action: "new" }
        format.json { render json: @available_date.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @available_date = @profile.available_dates.find(params[:id])

    respond_to do |format|
      if @available_date.update_attributes(params[:available_date])
        format.html { redirect_to profile_available_dates_path(@profile), :notice => 'Beschikbaarheid is aangepast.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @available_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @available_date = @profile.available_dates.find(params[:id])
    @available_date.destroy

    respond_to do |format|
      format.html { redirect_to profile_available_dates_url(@project) }
      format.json { head :no_content }
    end
  end

	def info
		render :layout => false
	end
end
