class Pubmed
  class Resource
    attr_accessor :type, :id, :response

    def initialize type: , id:
      self.type = type.to_s
      self.id = id.to_s
      self.get_response
    end

    def get_response
      if type == 'doi'
        self.response = get_details_from_doi(id)
      elsif type == 'pubmed'
        self.response = get_details(id)
      else
        self.response = nil
      end
    end

    def paper_attributes
      @paper_attributes ||= map_attributes
    end

    def map_attributes mapper: mapper(), data: response()
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

    def get_uid_from_doi doi
      response = Pubmed::Http.esearch(term: doi)
      parsed_data = Hash.from_xml(response.body)
      doi_not_found = parsed_data.dig "eSearchResult", "ErrorList", "PhraseNotFound"

      return nil if doi_not_found

      parsed_data.dig 'eSearchResult', 'IdList', 'Id', 0
    end

    def get_details(uid)
      return nil if uid.nil?
      Pubmed::Http.efetch(id: uid)
    end

    def get_details_from_doi(doi)
      return nil if doi.nil?

      uid = get_uid_from_doi(doi)
      Pubmed::Http.efetch(id: uid)
    end
  end
end
