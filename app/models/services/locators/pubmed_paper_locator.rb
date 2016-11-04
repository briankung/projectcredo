class PubmedPaperLocator < BaseLocator
  def column
    'pubmed_id'
  end

  def find_or_import_paper
    return super if super

    pubmed = Pubmed.new locator_type: 'pubmed', locator_id: locator_id
    paper_attributes = pubmed.paper_attributes

    if paper_attributes
      return Paper.create paper_attributes
    else
      return nil
    end
  end
end
