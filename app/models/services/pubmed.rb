class Pubmed
  def initialize(options={})
    @base_url = 'http://eutils.ncbi.nlm.nih.gov'
    @search_url = @base_url + "/entrez/eutils/esearch.fcgi"
    @metadata_url = @base_url + "/entrez/eutils/esummary.fcgi"
    @abstract_url = @base_url + "/entrez/eutils/efetch.fcgi"

    @default_parameters = {
      db: 'pubmed',
      retmode: 'json',
      retmax: 20
    }
    @default_parameters = @default_parameters.merge options if options.any?
  end

  def search(query)
    metadata_uri = generate_uri(
      @metadata_url,
      @default_parameters.merge(id: get_search_result_ids(query))
    )

    JSON.parse Net::HTTP.get(metadata_uri)
  end

  def get_abstract(uid)
    abstract_uri = generate_uri(@abstract_url, @default_parameters.merge(id: uid, retmode: 'xml'))

    abstract = Hash.from_xml(Net::HTTP.get(abstract_uri))['PubmedArticleSet']['PubmedArticle']['MedlineCitation']['Article']['Abstract']['AbstractText']
    abstract = abstract.join ' ' if abstract.respond_to? :join

    abstract
  end

  private
    def generate_uri(url, parameters)
      URI.parse(url + '?' + URI.encode_www_form(parameters))
    end

    def get_search_result_ids query
      query = query.gsub(' ', '+')
      search_uri = generate_uri @search_url, @default_parameters.merge(term: query)
      search_response = JSON.parse Net::HTTP.get(search_uri)

      # Someday: It would be nice to validate that these search results are in the format we expect
      search_response['esearchresult']['idlist'].join(",")
    end
end
