class Comments::VotesController < ApplicationController
  before_action :ensure_current_user
  before_action :set_comment

  def create
    current_user.likes @comment
    @comment.order_siblings

    redirect_to :back
  end

  def destroy
    current_user.unlike @comment
    @comment.order_siblings

    redirect_to :back
  end

  private
    def votable_params
      params.permit(:id)
    end

    def set_comment
      @comment = Comment.find(votable_params[:id])
    end
end
