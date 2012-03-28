class ItemsController < ApplicationController
	before_filter :get_project, :except => [:calendar]
	before_filter :authenticate_user!, :except => [:index, :update, :calendar]

	def get_project
		@project = Project.find(params[:project_id])
	end

  # GET /items
  # GET /items.json
  def index
    @items = @project.items.all
		render :layout => false
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

	def calendar
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

		@first_day_of_week = 1
		@event_strips = Project.all.event_strips_for_month(@shown_month, @first_day_of_week)
	end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = @project.items.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
				if params[:amount_to_give]
					@item.decrease_amount(params[:amount_to_give])
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
