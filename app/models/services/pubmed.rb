class Pubmed
  class Http
    def default_parameters
      {
        db: 'pubmed',
        retmode: 'json',
        retmax: 20
      }
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

    def efetch_url params = {}
      generate_uri(base_url + "/entrez/eutils/efetch.fcgi", default_parameters.merge(params))
    end

    def esearch term:
      parse_response(esearch_url term: term)
    end

    def esummary id:
      parse_response(esummary_url id: id)
    end

    def efetch id: , type:
      type = type.to_s
      parse_response(efetch_url(id: id, retmode: type), type: type)
    end

    private
      def generate_uri(url, parameters)
        URI.parse(url + '?' + URI.encode_www_form(parameters))
      end

      def parse_response uri, type: 'json'
        response = Net::HTTP.get(uri)
        if type.to_s == 'xml'
          return Hash.from_xml(CGI.unescapeHTML response) # This breaks if unescaped content has ampersands
        else
          return JSON.parse(response)
        end
      end
  end
end

class Pubmed
  class Resource
    attr_accessor :type, :id, :pubmed, :details

    def initialize type: , id: , pubmed: Pubmed.new
      self.type = type.to_s
      self.id = id.to_s
      self.pubmed = pubmed
      self.details()
    end

    def details
      return @details if @details

      if type == 'doi'
        self.details = pubmed.get_full_details(
          pubmed.get_uid_from_doi(id)
        )
      elsif type == 'pubmed'
        self.details = pubmed.get_full_details(id)
      else
        self.details = nil
      end
    end

    def paper_attributes legend: default_legend, parsed_data: details
      @paper_attributes ||= legend.inject({}) do |memo, _|
        attribute, hash_path = _[0], _[1]
        memo[attribute] = parsed_data.dig *hash_path
        memo
      end
    end

    def default_legend
      {
        title:          %w{PubmedArticleSet PubmedArticle MedlineCitation Article ArticleTitle},
        published_at:   %w{PubmedArticleSet PubmedArticle MedlineCitation Article Journal JournalIssue PubDate},
        abstract:       %w{PubmedArticleSet PubmedArticle MedlineCitation Article Abstract AbstractText},
        doi:            %w{PubmedArticleSet PubmedArticle MedlineCitation Article ELocationID},
        pubmed_id:      %w{PubmedArticleSet PubmedArticle MedlineCitation PMID},
        publication:    %w{PubmedArticleSet PubmedArticle MedlineCitation Article Journal Title},
        authors:        %w{PubmedArticleSet PubmedArticle MedlineCitation Article AuthorList}
      }
    end
  end
end

class Pubmed
  attr_accessor :http, :resource

  def initialize
    self.http = Pubmed::Http.new
  end

  def build_resource type: , id:
    self.resource = Pubmed::Resource.new type: type, id: id, pubmed: self
  end

  def get_search_result_ids query
    query = query.gsub(/\s/, '+')
    http.esearch(term: query).dig 'esearchresult', 'idlist'
  end

  def get_uid_from_doi doi
    results = http.esearch(term: doi)
    doi_not_found = results.dig *%w{esearchresult errorlist phrasesnotfound}

    if doi_not_found
      return nil
    else
      return results.dig 'esearchresult', 'idlist', 0
    end
  end

  def search(query)
    http.esummary id: get_search_result_ids(query).join(",")
  end

  def get_summary(uid)
    http.esummary(id: uid)
  end

  def get_full_details(uid)
    return nil if uid.nil?

    http.efetch(id: uid, type: 'xml')
  end

  def get_abstract(uid)
    full_details = get_full_details(uid)

    full_details.dig *%w{
      PubmedArticleSet
      PubmedArticle
      MedlineCitation
      Article
      Abstract
      AbstractText
    }
  end
end
