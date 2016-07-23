class ReferencesController < ApplicationController
  before_action :ensure_current_user

  def create
    list = List.find(params[:list_id])

    # Check if uuid. If not, then ask Pubmed.
    paper_id = params[:reference][:paper_id]
    if uuid? paper_id
      paper = Paper.find(paper_id)
    else
      pubmed = Pubmed.new
      results = pubmed.search paper_id
      data = results['result'][paper_id]
      paper = Paper.create(
        pubmed_id: data['uid'],
        title: data['title'],
        published_at: data['pubdate'],
        doi: data['elocationid'].sub(/^doi: /, "")
      )
    end

    Reference.create!(list_id: list.id, paper_id: paper.id)
    redirect_to list
  end

  def destroy
    reference = Reference.find(params[:id])
    list = reference.list
    reference.destroy
    redirect_to list
  end

  private
    def uuid?(string)
      uuid = /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}/
      uuid =~ string
    end
end
