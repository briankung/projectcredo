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
    if (paper = super) then return paper end

    return Paper.create title: paper_title, link: self.locator_id

  end
end
