class Pubmed
  attr_accessor :resource

  def initialize locator_id: nil
    self.resource = Pubmed::Resource.new locator_id
  end

  def self.get_uid_from_doi doi
    response = Pubmed::Http.esearch(term: doi)
    data = Nokogiri::XML(response.body)
    doi_not_found = (data.xpath("/eSearchResult/Count").text == '0')

    return nil if doi_not_found

    data.xpath('//IdList/Id').first.text
  end
end
