class DoiPaperLocator < BaseLocator
  def column
    'doi'
  end

  def find_or_import_paper
    return super if super

    paper = Paper.new

    crossref = Crossref.new
    result = crossref.get_doi_metadata(self.locator_id)
    if result[:error].blank?
      data = result['message']
      paper = crossref.import_data_to_paper(paper,data)
    end

    pubmed = Pubmed.new
    if (uid = pubmed.find_uid_by_doi(self.locator_id))
      result = pubmed.get_uid_metadata(uid)
      data = result['result'][uid]
      paper = pubmed.import_data_to_paper(paper,data)
    end

    existing_paper = Paper.where( "title = ? or pubmed_id = ? and pubmed_id is not null", paper.title, paper.pubmed_id ).first

    if existing_paper.present?
      return existing_paper
    elsif paper.save
      return paper
    else
      paper.errors.delete(:title)
      paper.errors.add(:locator_id, "is invalid; no paper found for searched DOI: #{self.locator_id}")
      return paper
    end

  end

end
