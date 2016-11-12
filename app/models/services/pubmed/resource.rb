class Pubmed
  class Resource
    attr_accessor :id, :response

    def initialize id
      self.id = id.to_s
      self.response = get_response(id)
    end

    def paper_attributes
      @paper_attributes ||= map_attributes mapper(), Nokogiri::XML(response.try(:body), &:noblanks)
    end

    def map_attributes mapper, data
      return nil unless data
      mapper.inject({}) do |memo, _|
        attribute, mapping = _[0], _[1]
        memo[attribute] = mapping.call(data)
        memo
      end
    end

    def mapper
      {
        title:              lambda {|data| data.css('ArticleTitle').text },
        publication:        lambda {|data| data.css('Journal Title').text },
        doi:                lambda {|data| data.css('ArticleId[IdType=doi]').text },
        pubmed_id:          lambda {|data| data.css('PMID').text },
        abstract:           lambda {|data| data.css('AbstractText').map(&:text).join("\n\n") },
        published_at:       lambda {|data| Date.parse data.css('PubDate').map(&:text).join(' ') },
        authors_attributes: lambda do |data|
          authors = data.css('AuthorList Author')
          authors.map do |author|
            {first_name: author.css("ForeName").text, last_name: author.css("LastName").text}
          end
        end
      }
    end

    def get_response uid
      return nil if uid.nil?
      Pubmed::Http.efetch(id: uid)
    end
  end
end
