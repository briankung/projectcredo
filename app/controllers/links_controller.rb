class LinksController < ApplicationController
  before_action :ensure_current_user

  def destroy
    link = Link.find(link_params[:id])
    link.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
    end
  end

  private

    def link_params
      params.permit(:id)
    end

end
