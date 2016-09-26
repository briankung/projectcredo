class Comments::VotesController < ApplicationController
  before_action :ensure_current_user
  before_action :set_comment

  def create
    current_user.likes @comment
    if @comment.parent_id
      closest_comment_by_votes = @comment.siblings.min_by {|c| (c.cached_votes_up - @comment.cached_votes_up).abs }
      if @comment.cached_votes_up >= closest_comment_by_votes.cached_votes_up
        closest_comment_by_votes.prepend_sibling(@comment)
      else
        closest_comment_by_votes.append_sibling(@comment)
      end
    end

    redirect_to :back
  end

  def destroy
    current_user.unlike @comment
    if @comment.parent_id
      closest_comment_by_votes = @comment.siblings.min_by {|c| (c.cached_votes_up - @comment.cached_votes_up).abs }
      if @comment.cached_votes_up >= closest_comment_by_votes.cached_votes_up
        closest_comment_by_votes.prepend_sibling(@comment)
      else
        closest_comment_by_votes.append_sibling(@comment)
      end
    end

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
