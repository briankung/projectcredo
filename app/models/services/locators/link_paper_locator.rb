class LinkPaperLocator
  attr_accessor :locator_id, :paper_title, :errors

  def initialize locator_id: , paper_title:
    self.locator_id = locator_id.strip
    self.paper_title = paper_title.strip
    self.errors = []
  end

  def find_or_import_paper
    if (link = Link.find_by url: locator_id)
      return link.paper
    else
      # save extra link details, mostly host
      # Grab different paper attributes depending on which host
      # Pubmed or Crossref can be used if pmid or doi is in the url
      # LinkScraper
      return Paper.create title: paper_title, links_attributes: [{url: locator_id}]
    end
  end

  def valid?
    is_url = !!locator_id.match(URI::regexp(%w(http https)))
    title_present = paper_title.present?

    errors << 'You must enter a title.' unless title_present
    errors << "\"#{locator_id}\" does not match URL format. Ex: \"http://example.org/article\"." unless is_url

    is_url && title_present
  end
end
