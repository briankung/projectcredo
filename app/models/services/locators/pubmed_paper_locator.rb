class PubmedPaperLocator < BaseLocator
  def column
    'pubmed_id'
  end

  def find_or_import_paper
    return super if super

    pubmed = Pubmed.new locator_id: locator_id
    paper_attributes = pubmed.resource.paper_attributes

    if paper_attributes
      response = pubmed.resource.response
      paper = Paper.create paper_attributes
      ApiImportResponse.create(xml: response.body, source_uri: response.uri.to_s, paper: paper)
      return paper
    else
      return nil
    end
  end
end
