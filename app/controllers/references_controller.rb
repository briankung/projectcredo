class ReferencesController < ApplicationController
  before_action :ensure_current_user

  def create
    begin
      reference_params.require(%i{type paper_id list_id})
    rescue ActionController::ParameterMissing => e
      missing_params = Set.new e.param[:reference]

      if missing_params.intersect? Set[:type, :paper_id]
        flash['alert'] = 'You must choose a paper identifier type and input an ID.'
      else
        flash['alert'] = 'You must choose a list to add to.'
      end

      redirect_to :back
      return
    end

    list = List.find(reference_params[:list_id])
    identifier = reference_params[:paper_id]
    id_type = reference_params[:type]

    unless (paper = find_or_import_paper(id_type, identifier))
      flash['alert'] = 'Paper not found.'
      return redirect_to(:back)
    end

    if Reference.exists? list_id: list.id, paper_id: paper.id
      flash['notice'] = 'This paper has already been added to this list'
    else
      Reference.create(list_id: list.id, paper_id: paper.id)
    end
    redirect_to list
  end

  def destroy
    if (reference = Reference.find_by(id: reference_params[:id]))
      reference.destroy
      redirect_to reference.list
    else
      redirect_to :back
    end
  end

  private
    def reference_params
      params.require(:reference).permit(:list_id, :paper_id, :id, :type)
    end

    def find_or_import_paper id_type, identifier
      case id_type
      when 'link'
        paper = Paper.find_by(link: identifier)
      when 'doi'
        paper = Paper.find_by(doi: identifier)
      when 'pubmed'
        paper = Paper.find_by(pubmed_id: identifier) || import_pubmed_paper(identifier)
      end
      return paper
    end

    def import_pubmed_paper identifier
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
