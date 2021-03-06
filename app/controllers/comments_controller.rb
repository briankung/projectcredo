class CommentsController < ApplicationController
  before_action :ensure_current_user
  before_action :set_comment, only: [:edit, :update, :destroy]

  # GET /lists/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
        format.js do
          reference = @comment.root.commentable
          is_top_level = !!@comment.commentable

          if is_top_level
            render('references/comments/create.js.erb', locals: { reference: reference })
          else
            render('comments/create.js.erb', locals: { reference: reference })
          end
        end
      else
        format.html { redirect_to :back }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    unless @comment.user == current_user
      flash[:alert] = "You do not have permission to edit this comment"
      return redirect_back(fallback_location: user_list_path(list.owner, list))
    end

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to :back, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
        format.js { render 'update.js.erb', locals: {reference: @comment.root.commentable} }
      else
        format.html { redirect_to :back, notice: 'Comment was not updated.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    reference = @comment.root.commentable
    list = reference.list

    respond_to do |format|
      if current_user.can_moderate?(list) || @comment.user == current_user
        @comment.destroy
        format.html { redirect_to :back, notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
        format.js { render 'destroy.js.erb', locals: {reference: reference} }
      else
        flash[:alert] = 'You do not have permission to moderate this list.'

        format.html { redirect_back fallback_location: user_list_path(list.owner, list) }
        format.js { ajax_redirect_to(user_list_path(list.owner, list)) }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :parent_id, :commentable_type, :commentable_id)
    end
end
