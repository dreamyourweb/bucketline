class ItemsController < ApplicationController
	before_filter :get_question, :except => [:calendar]
	before_filter :authenticate_user!, :except => [:index, :update, :edit, :calendar]

	def get_question
		@question = Question.find(params[:question_id])
	end

  # GET /items
  # GET /items.json
  def index
    @items = @question.items.all
		render :layout => false
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = @question.items.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = @question.items.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = @question.items.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to question_items_path(@question), notice: 'Item was successfully created.' }
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

    @event_strips = Question.last.items.event_strips_for_month(@shown_month)
	end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = @question.items.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to new_question_comment_path(@question) + "?belongs_to_item_id=" + @item.id.to_s, :notice => 'Bedankt dat je wilt meewerken aan de bouw! Hier onder kun je meer informatie kwijt over je bijdrage.' }
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
    @item = @question.items.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to question_items_url(@question) }
      format.json { head :no_content }
    end
  end
end
