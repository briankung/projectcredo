class PubmedPaperLocator < BaseLocator
  def column
    'pubmed_id'
  end

  def find_paper
    return super if super

    paper = Paper.new

    pubmed = Pubmed.new
    result = pubmed.get_uid_metadata(self.locator_id)
    if (data = result['result'][self.locator_id])
      paper = pubmed.import_data_to_paper(paper,data)
    end

    if paper.doi
      crossref = Crossref.new
      result = crossref.get_doi_metadata(self.locator_id)
      if result[:error].blank?
        data = result['message']
        paper = crossref.import_data_to_paper(paper,data)
      end
    end

    existing_paper = Paper.where( "title = ? or (doi = ? and doi is not null)", paper.title, paper.doi ).first

    if existing_paper.present?
      return existing_paper
    elsif paper.save
      return paper
    else
      paper.errors.delete(:title)
      paper.errors.add(:locator_id, "is invalid; no paper found for searched Pubmed ID: #{self.locator_id}")
      return paper
    end

  end
end
