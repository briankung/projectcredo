class PinsController < ApplicationController
  before_action :set_pinned_lists

  def create
    @pinned_lists << List.find(list_params[:list_id])
    redirect_to :back
  end

  def destroy
    @pinned_lists.destroy list_params[:list_id]
    redirect_to :back
  end

  private
    def set_pinned_lists
      @pinned_lists = current_user.homepage.lists
    end

    def list_params
      params.permit(:list_id)
    end
end
