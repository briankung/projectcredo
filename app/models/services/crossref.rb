class Crossref
  def initialize(options={})
    @base_url = 'http://api.crossref.org/'
    @metadata_url = @base_url + "works/"
    @funder_url = @base_url + "funders/"
  end

  def get_doi_metadata(doi)
    metadata_uri = URI.parse(@metadata_url+doi)
    JSON.parse Net::HTTP.get(metadata_uri) if valid_json? Net::HTTP.get(metadata_uri)
  end

  private

    def valid_json?(json)
      begin
        JSON.parse(json)
        return true
      rescue JSON::ParserError => e
        return false
      end
    end

end