class Crossref
  def initialize(options={})
    @base_url = 'http://api.crossref.org/'
    @metadata_url = @base_url + "works/"
    @funder_url = @base_url + "funders/"
  end

  def get_doi_metadata(doi)
    metadata_uri = URI.parse(@metadata_url+doi)
    if Net::HTTP.get_response(metadata_uri).is_a?(Net::HTTPSuccess)
      JSON.parse(Net::HTTP.get(metadata_uri))
    else
      return {error: 'no paper found in CrossRef'}
    end
  end

end