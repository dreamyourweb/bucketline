class ItemsController < ApplicationController
	before_filter :get_project, :except => [:dashboard]
	before_filter :authenticate_admin, :except => [:index, :update, :dashboard]
	before_filter :authenticate_user!, :except => [:index, :dashboard]

	def get_project
		@project = Project.find(params[:project_id])
	end

  # GET /items
  # GET /items.json
  def index
    @items = @project.items.all
		render :layout => false
  end

	def dashboard
    @help = Item.where(:type => "help").order_by(:updated_at, :desc)
    @tools = Item.where(:type => "tool").order_by(:updated_at, :desc)
    @materials = Item.where(:type => "material").order_by(:updated_at, :desc)

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
					@item.decrease_amount(params[:amount_to_give])
					@item.update_attributes(:provided_by_last_user_name => current_user.profile.name)
				end
        format.html { redirect_to projects_path, :notice => 'Bedankt dat je wilt meewerken aan de bouw!' }
        format.json { head :no_content }
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
end
