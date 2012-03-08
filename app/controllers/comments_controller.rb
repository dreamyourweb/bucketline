class CommentsController < ApplicationController
	before_filter :get_question
	before_filter :authenticate_user!, :except => [:index, :new, :create]

	def get_question
		@question = Question.find(params[:question_id])
	end

  # GET /comments
  # GET /comments.json
  def index
    @comments = @question.comments.all.order_by(:updated_at)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = @question.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = @question.comments.new
	if params[:fancybox]
		render :layout => false
	end
  end

  # GET /comments/1/edit
  def edit
    @comment = @question.comments.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @question.comments.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to questions_path, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = @question.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = @question.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
