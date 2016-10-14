class LinkPaperLocator < BaseLocator
  attr_accessor :paper_title

  def initialize locator_id, paper_title
    self.locator_id = locator_id.strip
    self.paper_title = paper_title.strip
  end

  def column
    'link'
  end

  def find_paper
    return super if super

    Paper.create title: paper_title, links_attributes: [{link: self.locator_id, link_type: 'paper'}]
  end
end
