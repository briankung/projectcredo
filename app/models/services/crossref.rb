class Crossref
  def initialize(options={})
    @base_url = 'http://api.crossref.org/'
    @metadata_url = @base_url + "works/"
    @funder_url = @base_url + "funders/"
  end

  def get_doi_metadata(doi)
    metadata_uri = URI.parse(@metadata_url+doi)
    begin
      JSON.parse Net::HTTP.get(metadata_uri)
    rescue JSON::ParserError => e
      return false
    end
  end

end