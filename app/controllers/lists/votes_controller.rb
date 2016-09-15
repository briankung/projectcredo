class Lists::VotesController < ApplicationController
  before_action :ensure_current_user

  def create
    current_user.likes List.find(votable_params[:id])

    redirect_to :back
  end

  def destroy
    current_user.unlike List.find(votable_params[:id])

    redirect_to :back
  end

  private
    def votable_params
      params.permit(:id)
    end
end
