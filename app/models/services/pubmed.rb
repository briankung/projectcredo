class Pubmed
  class Http
    def self.default_parameters
      {
        db: 'pubmed',
        retmode: 'xml',
        retmax: 20
      }
    end

    def self.base_url
      'https://eutils.ncbi.nlm.nih.gov'
    end

    def self.esearch options = {}
      uri = generate_uri("/entrez/eutils/esearch.fcgi", default_parameters.merge(options))

      Net::HTTP.get_response(uri)
    end

    def self.esummary options = {}
      uri = generate_uri("/entrez/eutils/esummary.fcgi", default_parameters.merge(options))

      Net::HTTP.get_response(uri)
    end

    def self.efetch options = {}
      uri = generate_uri("/entrez/eutils/efetch.fcgi", default_parameters.merge(options))

      Net::HTTP.get_response(uri)
    end

    def self.generate_uri(url, parameters)
      URI.parse("#{base_url}#{url}?" + URI.encode_www_form(parameters))
    end
  end
end

class Pubmed
  class Resource
    attr_accessor :type, :id, :details

    def initialize type: , id:
      self.type = type.to_s
      self.id = id.to_s
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
        doi:                lambda {|data| data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article ELocationID}},
        pubmed_id:          lambda {|data| data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation PMID}},

        abstract:           lambda {|data|
          abstract = data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article Abstract AbstractText}
          if abstract.respond_to?(:join) then abstract.join("\n\n") else abstract end
        },

        published_at:       lambda {|data|
          pubdate = data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article Journal JournalIssue PubDate}
          Date.parse pubdate.values_at("Year", "Month", "Day").join(' ')
        },

        authors_attributes: lambda {|data|
          authors = data.dig *%w{PubmedArticleSet PubmedArticle MedlineCitation Article AuthorList Author}
          authors.map do |author|
            {name: author.values_at("ForeName", "LastName").join(' ')}
          end
        },

        data_from_import:   lambda {|data| data}
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

    def self.search(query)
      Pubmed::Core.get_summaries *get_search_result_ids(query)
    end

    def self.get_summaries(*uids)
      Pubmed::Http.esummary(id: uids.join(','))
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

    def self.get_uid_from_doi doi
      results = Pubmed::Http.esearch(term: doi)
      doi_not_found = results.dig *%w{esearchresult errorlist phrasesnotfound}

      if doi_not_found
        return nil
      else
        return results.dig 'esearchresult', 'idlist', 0
      end
    end
  end
end

class Pubmed
  attr_accessor :type, :id

  def initialize  type: nil, id: nil
    @type, @id = type, id
  end

  def paper_attributes type: type(), id: id()
    resource = Pubmed::Resource.new type: type, id: id
    resource.paper_attributes
  end
end
