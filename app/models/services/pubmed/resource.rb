class Pubmed
  class Resource
    attr_accessor :type, :id, :response

    def initialize type, id
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

    def get_uid_from_doi doi
      response = Pubmed::Http.esearch(term: doi)
      data = Nokogiri::XML(response.body)
      doi_not_found = data.xpath("//PhraseNotFound").any?

      return nil if doi_not_found

      data.xpath('//IdList/Id').first.text
    end

    def get_details uid
      return nil if uid.nil?
      Pubmed::Http.efetch(id: uid)
    end

    def get_details_from_doi doi
      return nil if doi.nil?

      uid = get_uid_from_doi(doi)
      Pubmed::Http.efetch(id: uid)
    end
  end
end
