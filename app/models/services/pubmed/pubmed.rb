class Pubmed
  attr_accessor :resource

  def initialize locator_type: nil, locator_id: nil
    @resource = Pubmed::Resource.new type: locator_type, id: locator_id
  end
end
