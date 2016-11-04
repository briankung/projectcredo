require 'resource'

class Pubmed
  attr_accessor :resource

  def initialize locator_type: nil, locator_id: nil
    @resource = Pubmed::Resource.new locator_type, locator_id
  end
end
