class DoiPaperLocator
  attr_accessor :locator_id

  def initialize locator_id:
    self.locator_id = locator_id.strip
  end

  def find_or_import_paper
    existing_paper = Paper.find_by doi: locator_id
    return existing_paper if existing_paper

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
