class ProjectsController < ApplicationController
	before_filter :authenticate_admin, :except => [:index, :info]

  # GET /questions
  # GET /questions.json
  def index
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

		@first_day_of_week = 1
		@event_strips = Project.all.event_strips_for_month(@shown_month, @first_day_of_week)
  end

	def info
		render :layout => false
	end

  def new
    @project = Project.new
		@admins = User.where(:admin => true).all
    item = @project.items.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  def edit
    @project = Project.find(params[:id])
		@admins = User.where(:admin => true).all
  end

  def create
    @project = Project.new(params[:project])
		@admins = User.where(:admin => true).all

    respond_to do |format|
      if @project.save
				#@project.send_project_placement_mail
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
    @admins = User.where(:admin => true).all

    respond_to do |format|
      if @project.update_attributes(params[:project])
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
