class ProjectsController < ApplicationController
  before_filter :get_initiative
	before_filter :authenticate_admin_for_initiative, :except => [:index, :info]
  before_filter :authenticate_user_for_initiative, :only => [:index, :info]

  # GET /questions
  # GET /questions.json
  def index
		session[:initiative_id] = params[:initiative_id]
		@initiative = Initiative.find(params[:initiative_id])

    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

		@first_day_of_week = 1
		@event_strips = @initiative.projects.all.event_strips_for_month(@shown_month, @first_day_of_week)
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
        #Items are created after project is created, so if this method is called by an after_create hook, project.items is still empty when the mail is sent. That's why it is called by the controller.
				@project.send_project_placement_mail
        format.html { redirect_to initiative_projects_path(@initiative), notice: 'Het project is geplaatst' }
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
        format.html { redirect_to initiative_projects_path(@initiative), notice: 'Het project is bijgewerkt' }
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
      format.html { redirect_to initiative_projects_url(@initiative) }
      format.json { head :no_content }
    end
  end
end
