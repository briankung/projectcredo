class LinkPaperLocator < BaseLocator
  attr_accessor :paper_title

  def initialize locator_id, paper_title
    self.locator_id = locator_id.strip
    self.paper_title = paper_title.strip
  end

  def column
    'link'
  end

  def find_or_import_paper
    if (link = Link.find_by url: self.locator_id)
      return link.paper
    else
      return Paper.create title: paper_title, links_attributes: [{url: self.locator_id}]
    end
  end
end
