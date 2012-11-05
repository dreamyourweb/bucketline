class ItemsController < ApplicationController
	before_filter :get_initiative
	before_filter :authenticate_admin_for_initiative, :except => [:index, :update, :dashboard, :info]
	before_filter :authenticate_user_for_initiative, :except => [:index, :dashboard, :info]

	def new
		@item = @initiative.items.new
    #TODO admin scope over initiative
    @admins = @initiative.admins
	end
	
	def edit
		@item = Item.find(params[:id])
    #TODO admin scope over initiative
    @admins = @initiative.admins
	end

  # GET /items
  # GET /items.json
  def index
		@project = Project.find(params[:project_id])
    @items = @project.items.all
		@owner = @project.owner
    if current_user
      @profile = current_user.profile
    end
		@contributing_users = @project.contributing_users
		render :layout => false
  end

	def dashboard
		#@projects = Project.excludes(:success => true).order_by(:start_at, :asc) #find all unfinished projects
		@vervoer = []
		@in_en_om_het_huis = []
		@oppas_en_gezelschap = []
    @boodschappen_en_koken = []
    @profile = current_user.profile
    if params[:show_all_items]
      @items = @initiative.items.where(:project_id => nil).all
		else
      @items = @initiative.items.where(:project_id => nil, :success => false).all
    end
		@items.each do |item|
			if item.type == "vervoer"
				@vervoer << item
			elsif item.type == "in en om het huis"
				@in_en_om_het_huis << item
			elsif item.type == "oppas en gezelschap"
				@oppas_en_gezelschap << item
      else
        @boodschappen_en_koken << item
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
		#@project = Item.find(params[:id]).project
    #@item = @project.items.new(params[:item])
		@item = @initiative.items.new(params[:item])

    #TODO admin scope over initiative
    @admins = @initiative.admins

    respond_to do |format|
      if @item.save
        format.html { redirect_to dashboard_path, notice: 'Item is geplaatst' }
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
		if params[:project_id]
			@project = Project.find(params[:project_id])
		end
    @item = Item.find(params[:id])

    #TODO admin scope over initiative
    @admins = @initiative.admins

    respond_to do |format|
      if @item.update_attributes(params[:item])
				if params[:amount_to_give]
					@profile = current_user.profile
					@link = Link.where(:profile_id => @profile.id, :item_id => @item.id).first
					if @link
						@link.amount += params[:amount_to_give].to_i
						@link.save
					else
						@link = @item.links.create(:amount => params[:amount_to_give].to_i, :profile_id => @profile.id)
						@profile.links << @link
						@profile.save
            #Contribution mail is sent from controller, because if it is sent by an after_create hook, for some mysterious reason it is sent twice
            @link.send_contribution_mail
					end
				end
				if params[:redirect_to_dashboard] && params[:amount_to_give]
        	format.html { redirect_to dashboard_path, :notice => 'Bedankt voor je bijdrage!' }
        	format.json { head :no_content }
				elsif params[:amount_to_give]
        	format.html { redirect_to projects_path, :notice => 'Bedankt voor je bijdrage!' }
        	format.json { head :no_content }
				else
        	format.html { redirect_to dashboard_path, :notice => 'Item is bijgewerkt' }
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
    @item = Item.find(params[:id])
		#@project = @item.project
    @item.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_path, :notice => "Item is verwijderd" }
      format.json { head :no_content }
    end
  end

	def info
		render :layout => false
	end
end
