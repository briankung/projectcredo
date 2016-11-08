class Pubmed
  attr_accessor :resource

  def initialize locator_type: nil, locator_id: nil
    @resource = Pubmed::Resource.new locator_type, locator_id
  end

  def self.get_uid_from_doi doi
    response = Pubmed::Http.esearch(term: doi)
    data = Nokogiri::XML(response.body)
    doi_not_found = data.xpath("//PhraseNotFound").any?

    return nil if doi_not_found

    data.xpath('//IdList/Id').first.text
  end
end
