class AvailableDatesController < ApplicationController
	before_filter :authenticate_user!, :get_profile
	
	def get_profile
		@profile = current_user.profile
	end

  def index
    @available_dates = @profile.available_dates.all

    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

		@first_day_of_week = 1
		@event_strips = current_user.profile.available_dates.all.event_strips_for_month(@shown_month, @first_day_of_week)
		p @event_strips

		respond_to do |format|
      format.html
      format.json { render json: @available_dates }
		end
  end

  def create
    @available_date = @profile.available_dates.new(params[:available_date])

    respond_to do |format|
      if @available_date.save
        format.html { redirect_to profile_available_dates_path(@project), notice: 'Beschikbaarheid is aangepast.' }
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
end
