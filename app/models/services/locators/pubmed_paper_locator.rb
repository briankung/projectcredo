class PubmedPaperLocator < BaseLocator
  def column
    'pubmed_id'
  end

  def find_or_import_paper
    return super if super

    pubmed = Pubmed.new
    result = pubmed.get_uid_metadata(self.locator_id)['result']
    if (data = result[self.locator_id])
      return Paper.create pubmed.mapper.paper_attributes
    else
      return nil
    end
  end
end
