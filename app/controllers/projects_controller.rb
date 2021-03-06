class ProjectsController < ApplicationController
  # helper LaterDude::CalendarHelper

  before_filter :get_initiative
	before_filter :authenticate_admin_for_initiative, :except => [:index, :info]
  before_filter :authenticate_user_for_initiative, :only => [:index, :info]

  # GET /questions
  # GET /questions.json
  def index
		# session[:initiative_id] = params[:initiative_id]

		# @initiative = Initiative.where(slug: request.subdomain).first

    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    
    @current_month = Date.civil(@year, @month)
    @first_day_month = Date.civil(@year, @month)
    @last_day_month = Date.civil(@year, @month, -1) + 1

		@first_day_of_week = 1

    @events_hash = Array.new

    @events = @initiative.projects.where(:start_at.gte => @first_day_month, :start_at.lte => @last_day_month).asc(:start_at).each do |e|
      @events_hash[e.start_at.day] = [] if @events_hash[e.start_at.day].nil?;
      @events_hash[e.start_at.day].push(e)
    end

		# @event_strips = @initiative.projects.all.event_strips_for_month(@shown_month, @first_day_of_week)
    # @events_hash = @initiative.events_hash_for_month(@shown_month)
  end

	def info
		render :layout => false
	end

  def new
    @project = @initiative.projects.new
		@admins = @initiative.admins
    item = @project.items.build #appends an empty item to the form

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
		@admins = @initiative.admins
  end

  def create
    @project = @initiative.projects.new(params[:project])
		@admins = @initiative.admins

    respond_to do |format|
      if @project.save
        #Mails for project creation are sent hourly by a rake task.
        format.html { redirect_to projects_path, notice: 'Het project is geplaatst' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])
    @admins = @initiative.admins

    respond_to do |format|
      if @project.update_attributes(params[:project])
        #Items are updated after project is updated, so if this method is called by an after_create hook, project.items is old when the mail is sent. That's why it is called by the controller.
        @project.send_project_update_mail
        format.html { redirect_to projects_path, notice: 'Het project is bijgewerkt' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
