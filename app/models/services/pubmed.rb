class Pubmed
  attr_accessor :default_parameters

  def initialize(options={})
    self.default_parameters = {
      db: 'pubmed',
      retmode: 'json',
      retmax: 20
    }.merge(options)
  end

  def base_url
    'https://eutils.ncbi.nlm.nih.gov'
  end

  def esearch_url params = {}
    generate_uri(base_url + "/entrez/eutils/esearch.fcgi", default_parameters.merge(params))
  end

  def esummary_url params = {}
    generate_uri(base_url + "/entrez/eutils/esummary.fcgi", default_parameters.merge(params))
  end

  def pubmed_article_url uid, params = {}
    generate_uri('https://www.ncbi.nlm.nih.gov/pubmed/' + uid, params)
  end

  def search(query)
    parse_response(esummary_url id: get_search_result_ids(query).join(","))
  end

  def get_uid_metadata(uid)
    parse_response(esummary_url id: uid)
  end

  def get_abstract(uid)
    result = parse_response(pubmed_article_url(uid, report: 'xml'), type: :xml)
    abstract = result.dig *%w{
      pre
      PubmedArticle
      MedlineCitation
      Article
      Abstract
      AbstractText
    }

    return abstract
  end

  def get_search_result_ids query
    query = query.gsub(/\s/, '+')
    search_response = JSON.parse Net::HTTP.get(esearch_url term: query)
    search_response.dig 'esearchresult', 'idlist'
  end

  def find_uid_by_doi doi
    search_response = JSON.parse Net::HTTP.get(esearch_url term: doi)
    search_response.dig 'esearchresult', 'idlist', 0
  end

  private
    def generate_uri(url, parameters)
      URI.parse(url + '?' + URI.encode_www_form(parameters))
    end

    def parse_response uri, type: 'json'
      response = Net::HTTP.get(uri)
      if type.to_s == 'xml'
        return Hash.from_xml(CGI.unescapeHTML response)
      else
        return JSON.parse(response)
      end
    end
end
