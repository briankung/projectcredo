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
        self.response = Pubmed::Core.get_details_from_doi(id)
      elsif type == 'pubmed'
        self.response = Pubmed::Core.get_details(id)
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
  end
end
