class ReferencesController < ApplicationController
  def create
    list = List.find(params[:list_id])
    paper = Paper.find(params[:reference][:paper_id])
    Reference.create!(list_id: list.id, paper_id: paper.id)
    redirect_to list
  end

  def destroy
    Reference.find(params[:id]).destroy
    redirect_to list
  end
end
