class Pubmed
  class Http
    def self.default_parameters
      {
        db: 'pubmed',
        retmode: 'json',
        retmax: 20
      }
    end

    def self.base_url
      'https://eutils.ncbi.nlm.nih.gov'
    end

    def self.esearch_url params = {}
      generate_uri(base_url + "/entrez/eutils/esearch.fcgi", default_parameters.merge(params))
    end

    def self.esummary_url params = {}
      generate_uri(base_url + "/entrez/eutils/esummary.fcgi", default_parameters.merge(params))
    end

    def self.efetch_url params = {}
      generate_uri(base_url + "/entrez/eutils/efetch.fcgi", default_parameters.merge(params))
    end

    def self.esearch term:
      parse_response(esearch_url term: term)
    end

    def self.esummary id:
      parse_response(esummary_url id: id)
    end

    def self.efetch id: , type:
      type = type.to_s
      parse_response(efetch_url(id: id, retmode: type), type: type)
    end

    def self.generate_uri(url, parameters)
      URI.parse(url + '?' + URI.encode_www_form(parameters))
    end

    def self.parse_response uri, type: 'json'
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
        self.details = Pubmed::Core.get_details_from_doi(id)
      elsif type == 'pubmed'
        self.details = Pubmed::Core.get_details(id)
      else
        self.details = nil
      end
    end

    def paper_attributes
      @paper_attributes ||= map_attributes
    end

    def map_attributes mapper: mapper(), data: details()
      return nil unless data
      mapper.inject({}) do |memo, _|
        attribute, mapping = _[0], _[1]
        memo[attribute] = mapping.call(data)
        memo
      end
    end

    def mapper
      {
        title:              lambda {|data| data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article ArticleTitle}},
        publication:        lambda {|data| data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article Journal Title}},
        abstract:           lambda {|data| data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article Abstract AbstractText}},
        doi:                lambda {|data| data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article ELocationID}},
        pubmed_id:          lambda {|data| data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation PMID}},
        published_at:       lambda {|data|
          pubdate = data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article Journal JournalIssue PubDate}
          Date.parse pubdate.values_at("Year", "Month", "Day").join(' ')
        },
        authors_attributes: lambda {|data|
          authors = data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article AuthorList Author}
          authors.map do |author|
            {name: author.values_at("ForeName", "LastName").join(' ')}
          end
        }
      }
    end
  end
end

class Pubmed
  class Core
    def self.get_search_result_ids query
      query = query.gsub(/\s/, '+')
      Pubmed::Http.esearch(term: query).dig 'esearchresult', 'idlist'
    end

    def self.get_uid_from_doi doi
      results = Pubmed::Http.esearch(term: doi)
      doi_not_found = results.dig *%w{esearchresult errorlist phrasesnotfound}

      if doi_not_found
        return nil
      else
        return results.dig 'esearchresult', 'idlist', 0
      end
    end

    def self.search(query)
      Pubmed::Core.get_summaries get_search_result_ids(query).join(",")
    end

    def self.get_summaries(uid)
      Pubmed::Http.esummary(id: uid)
    end

    def self.get_details(uid)
      return nil if uid.nil?
      Pubmed::Http.efetch(id: uid, type: 'xml')
    end

    def self.get_details_from_doi(doi)
      return nil if doi.nil?

      Pubmed::Http.efetch(
        id: Pubmed::Core.get_uid_from_doi(doi),
        type: 'xml'
      )
    end
  end
end

class Pubmed
  attr_reader :type, :id

  def initialize  type: nil, id: nil
    @type, @id = type, id
  end

  def paper_attributes type: type(), id: id()
    resource = Pubmed::Resource.new type: type, id: id
    resource.paper_attributes
  end
end
