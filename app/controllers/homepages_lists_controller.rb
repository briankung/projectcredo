class HomepagesListsController < ApplicationController
  before_action :set_homepage

  def create
    @homepage.lists << List.find(list_params[:list_id])
    redirect_to :back
  end

  def destroy
    @homepage.lists.destroy list_params[:list_id]
    redirect_to :back
  end

  private
    def set_homepage
      @homepage = current_user.homepage
    end

    def list_params
      params.permit(:list_id)
    end
end
