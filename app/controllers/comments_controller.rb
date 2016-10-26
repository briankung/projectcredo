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
        reference = @comment.root.commentable
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
        format.js { render( @comment.parent.nil? ? 'comment_on_reference.js.erb' : 'reply_to_comment.js.erb', locals: {reference: reference} )}

      else
        format.html { redirect_to :back }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render( @comment.parent.nil? ? 'comment_on_reference.js.erb' : 'reply_to_comment.js.erb', locals: {reference: reference} )}
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        reference = @comment.root.commentable
        format.html { redirect_to :back, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
        format.js { render 'reference_comments.js.erb', locals: {reference: reference} }
      else
        format.html { redirect_to :back, notice: 'Comment was not updated.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render 'reference_comments.js.erb', locals: {reference: reference} }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    reference = @comment.root.commentable
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
      format.js { render 'reference_comments.js.erb', locals: {reference: reference} }
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
