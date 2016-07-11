class ReferencesController < ApplicationController
  before_action :ensure_current_user

  def create
    list = List.find(params[:list_id])
    paper = Paper.find(params[:reference][:paper_id])
    Reference.create!(list_id: list.id, paper_id: paper.id)
    redirect_to list
  end

  def destroy
    reference = Reference.find(params[:id])
    list = reference.list
    reference.destroy
    redirect_to list
  end
end
