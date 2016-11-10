class DoiPaperLocator < BaseLocator
  def column
    'doi'
  end

  def find_or_import_paper
    return super if super

    paper = Paper.new

    crossref = Crossref.new locator_id: locator_id
    paper_attributes = crossref.resource.paper_attributes

    if paper_attributes
      response = crossref.resource.response
      paper = Paper.create paper_attributes
      paper.api_import_responses.create(json: JSON.parse(response.body), source_uri: response.uri.to_s)
      return paper
    else
      return nil
    end
  end
end
