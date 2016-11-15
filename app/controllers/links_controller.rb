class LinksController < ApplicationController
  before_action :ensure_current_user

  def destroy
    link = Link.find(link_params[:id])
    url = link.url
    link.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: "'#{url}' has been successfully removed" }
    end
  end

  private

    def link_params
      params.permit(:id)
    end

end
