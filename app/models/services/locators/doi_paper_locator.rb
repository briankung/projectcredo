class DoiPaperLocator < BaseLocator
  def column
    'doi'
  end

  def find_paper
    return super if super

    paper = Paper.new

    crossref = Crossref.new
    if result = crossref.get_doi_metadata(self.locator_id)
      data = result['message']
      paper = self.import_data_to_paper(paper,data,'crossref')
    end

    pubmed = Pubmed.new
    if uid = pubmed.find_uid_by_doi(self.locator_id)
      result = pubmed.get_uid_metadata(uid)
      data = result['result'][uid]
      paper = self.import_data_to_paper(paper,data,'pubmed')
    end

    if paper.save
      return paper
    else
      paper.errors.add(:locator_id, "is invalid; no paper found for searched DOI: #{self.locator_id}") if paper.errors.empty?
      return paper
    end
  end
end
