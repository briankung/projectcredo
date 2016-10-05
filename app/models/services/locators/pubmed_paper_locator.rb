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
      paper = self.import_data_to_paper(paper,data,'pubmed')
    end

    if paper.doi
      crossref = Crossref.new
      if result = crossref.get_doi_metadata(self.locator_id)
        data = result['message']
        paper = self.import_data_to_paper(paper,data,'crossref')
      end
    end

    existing_paper = Paper.where( "title = ? or doi = ? and doi is not null", paper.title, paper.doi )

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