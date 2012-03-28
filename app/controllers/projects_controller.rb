class ProjectsController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]

  # GET /questions
  # GET /questions.json
  def index
    @projects = Project.all
    @help = Item.where(:type => "help").order_by(:updated_at, :desc)
    @tools = Item.where(:type => "tool").order_by(:updated_at, :desc)
    @materials = Item.where(:type => "material").order_by(:updated_at, :desc)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  def new
    @project = Project.new
    item = @project.items.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to root_path, notice: 'De vraag is geplaatst' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])

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
