class BaseLocator
  attr_accessor :column, :locator_id

  def initialize locator_id
    self.locator_id = locator_id.strip
  end

  def find_paper
    Paper.find_by self.column => self.locator_id
  end
end