class ItemsController < ApplicationController
	before_filter :get_project, :except => [:dashboard, :info]
	before_filter :authenticate_admin, :except => [:index, :update, :dashboard, :info]
	before_filter :authenticate_user!, :except => [:index, :dashboard, :info]

	def get_project
		@project = Project.find(params[:project_id])
	end

  # GET /items
  # GET /items.json
  def index
    @items = @project.items.all
		@owner = @project.owner
		@contributing_users = @project.contributing_users
		if !@owner.nil?
			@owner_profile = @owner.profile
		end
		render :layout => false
  end

	def dashboard
		@projects = Project.excludes(:success => true).order_by(:start_at, :asc) #find all unfinished projects
		@help = []
		@tools = []
		@materials = []
		@projects.each do |project|
			project.items.each do |item|
				if item.type == "help"
					@help << item
				elsif item.type == "tool"
					@tools << item
				else
					@materials << item
				end
			end
		end
    #@help = Item.where(:type => "help").order_by(:start_at, :asc)
    #@tools = Item.where(:type => "tool").order_by(:start_at, :asc)
    #@materials = Item.where(:type => "material").order_by(:start_at, :asc)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: Item.all.entries }
    end
	end

  # POST /items
  # POST /items.json
  def create
    @item = @project.items.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to project_items_path(@project), notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = @project.items.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
				if params[:amount_to_give]
					@profile = current_user.profile
					@item.link_to_profile(params[:amount_to_give].to_i, @profile)
					@profile.link_to_item(params[:amount_to_give].to_i, @item)
				end
				if params[:redirect_to_dashboard]
        	format.html { redirect_to dashboard_path, :notice => 'Bedankt voor je bijdrage!' }
        	format.json { head :no_content }
				else
        	format.html { redirect_to projects_path, :notice => 'Bedankt voor je bijdrage!' }
        	format.json { head :no_content }
				end
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = @project.items.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to project_items_url(@project) }
      format.json { head :no_content }
    end
  end

	def info
		render :layout => false
	end
end
