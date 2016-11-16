class LinksController < ApplicationController
  before_action :ensure_current_user

  def destroy
    link = Link.find(link_params[:id])
    url = link.url
    paper = link.paper.title
    link.destroy

    reference = Reference.find(params[:reference_id])
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: "'#{url}' has been successfully removed from '#{paper}'") }
      format.js { render('papers/destroy_link.js.erb', locals: { reference: reference }) }
    end
  end

  private

    def link_params
      params.permit(:id)
    end

end
