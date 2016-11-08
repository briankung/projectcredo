class Pubmed
  class Resource
    attr_accessor :id, :response

    def initialize id
      self.id = id.to_s
      self.response = get_details(id)
    end

    def paper_attributes
      @paper_attributes ||= map_attributes mapper(), Nokogiri::XML(response.try(:body))
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
        title:              lambda {|data| data.xpath('//ArticleTitle').text },
        publication:        lambda {|data| data.xpath('//Journal/Title').text },
        doi:                lambda {|data| data.xpath('//ELocationID').text },
        pubmed_id:          lambda {|data| data.xpath('//PMID').text },
        abstract:           lambda {|data| data.xpath('//AbstractText').map(&:text).join("\n\n") },
        published_at:       lambda {|data| Date.parse data.xpath('//PubDate').map(&:text).join(' ') },
        authors_attributes: lambda {|data| authors = data.xpath('//AuthorList/Author')
          authors.map do |author|
            {name: [author.xpath("ForeName"), author.xpath("LastName")].join(' ')}
          end
        }
      }
    end

    def get_details uid
      return nil if uid.nil?
      Pubmed::Http.efetch(id: uid)
    end
  end
end
