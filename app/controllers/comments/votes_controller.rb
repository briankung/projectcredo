class Comments::VotesController < ApplicationController
  before_action :ensure_current_user

  def create
    current_user.likes Comment.find(votable_params[:id])

    redirect_to :back
  end

  def destroy
    current_user.unlike Comment.find(votable_params[:id])

    redirect_to :back
  end

  private
    def votable_params
      params.permit(:id)
    end
end
