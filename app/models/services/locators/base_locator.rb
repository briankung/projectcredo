class BaseLocator
  attr_accessor :column, :locator_id

  def initialize locator_id
    self.locator_id = locator_id.strip
  end

  def find_paper
    if self.column == 'link'
      if (link = Link.find_by link: self.locator_id)
        paper = link.paper
      end
    else
      paper = Paper.find_by self.column => self.locator_id
    end

    return paper
  end

end