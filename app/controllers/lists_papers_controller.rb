class ListsPapersController < ApplicationController
  def create
    list = List.find(params[:list_id])
    paper = Paper.find(params[:list_paper][:paper_id])
    ListPaper.create!(list_id: list.id, paper_id: paper.id)
    redirect_to list
  end

  def destroy
    ListPaper.find(params[:id]).destroy
    redirect_to list
  end
end
