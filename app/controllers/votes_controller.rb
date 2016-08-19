class VotesController < ApplicationController
  before_action :ensure_current_user

  def create
    if votable_params[:type] == 'list'
      current_user.likes List.find(votable_params[:id])
    elsif votable_params[:type] == 'reference'
      current_user.likes Reference.find(votable_params[:id])
    else
      flash['notice'] = "You can't vote on this"
    end
    redirect_to :back
  end

  def destroy
    if votable_params[:type] == 'list'
      current_user.unlike List.find(votable_params[:id])
    elsif votable_params[:type] == 'reference'
      current_user.unlike Reference.find(votable_params[:id])
    else
      flash['notice'] = "You can't vote on this"
    end
    redirect_to :back
  end

  private
    def votable_params
      params.permit(:type, :id)
    end
end
