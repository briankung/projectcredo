class Crossref
  attr_accessor :metadata_uri, :resource

  def initialize locator_id: nil
    self.resource = Crossref::Resource.new locator_id
  end
end
