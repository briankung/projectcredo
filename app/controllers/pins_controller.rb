class PinsController < ApplicationController
  before_action :ensure_current_user
  before_action :set_pinned_lists

  def create
    @pinned_lists << List.find_by(slug: list_params[:id])
    redirect_to :back
  end

  def destroy
    list = @pinned_lists.find_by(slug: list_params[:id])
    @pinned_lists = @pinned_lists.delete(list)
    redirect_to :back
  end

  private
    def set_pinned_lists
      @pinned_lists = current_user.homepage.lists
    end

    def list_params
      params.permit(:id)
    end
end
