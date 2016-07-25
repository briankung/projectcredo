class ReferencesController < ApplicationController
  before_action :ensure_current_user

  # Shame: refactor the hell out of this
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
      authors = data['authors'].map {|a| {name: a['name']}}
      paper = (
        Paper.find_by(pubmed_id: paper_id) ||
        Paper.find_by(doi: paper_id) ||
        # I really hate this due to long experience with it,
        # but we should probably some sort of mapping
        Paper.create(
          pubmed_id: data['uid'],
          title: data['title'],
          published_at: data['pubdate'],
          authors_attributes: authors,
          doi: data['elocationid'].sub(/^doi: /, "")
        )
      )
    end

    if Reference.exists? list_id: list.id, paper_id: paper.id
      flash['notice'] = 'This paper has already been added to this list'
    else
      Reference.create(list_id: list.id, paper_id: paper.id)
    end
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
