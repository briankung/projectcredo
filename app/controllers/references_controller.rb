class ReferencesController < ApplicationController
  before_action :ensure_current_user

  def create
    list = List.find(reference_params[:list_id])

    # Check if uuid. If not, then ask Pubmed.
    identifier = reference_params[:paper_id]
    paper = find_paper(identifier) || import_paper(identifier)

    if Reference.exists? list_id: list.id, paper_id: paper.id
      flash['notice'] = 'This paper has already been added to this list'
    else
      Reference.create(list_id: list.id, paper_id: paper.id)
    end
    redirect_to list
  end

  def destroy
    reference = Reference.find(reference_params[:id])
    list = reference.list
    reference.destroy
    redirect_to list
  end

  private
    def reference_params
      params.require(:reference).permit(:list_id, :paper_id, :id)
    end

    def find_paper identifier
      if UUID_FORMAT =~ identifier
        paper = Paper.find(identifier)
      elsif /\// =~ identifier
        paper = Paper.find_by(doi: identifier)
      else
        paper = Paper.find_by(pubmed_id: identifier)
      end
      return paper
    end

    def import_paper identifier
      pubmed = Pubmed.new
      data = pubmed.search(identifier)['result'][identifier]

      existing_authors, new_authors = [], []

      data['authors'].each do |author_data|
        if (author = Author.find_by name: author_data['name'])
          existing_authors << author
        else
          new_authors << {name: author_data['name']}
        end
      end

      paper = Paper.create(
        pubmed_id: data['uid'],
        title: data['title'],
        published_at: data['pubdate'],
        authors_attributes: new_authors,
        abstract: pubmed.get_abstract(data['uid']),
        doi: data['elocationid'].sub(/^doi: /, ""),
        publication: data['source']
      )
      paper.authors.push *existing_authors unless existing_authors.empty?
      return paper
    end
end
