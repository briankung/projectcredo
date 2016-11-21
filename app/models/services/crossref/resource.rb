class Crossref
  class Resource
    attr_accessor :id, :response

    def initialize id
      self.id = id.to_s
      endpoint = URI.parse("https://api.crossref.org/works/#{self.id}")
      self.response = Net::HTTP.get_response endpoint
    end

    def paper_attributes
      if response.code_type.ancestors.include? Net::HTTPSuccess
        data = JSON.parse response.body
        @paper_attributes ||= map_attributes(mapper, data)
      else
        @paper_attributes = nil
      end
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
        import_source:      lambda {|data| 'crossref' },
        title:              lambda {|data| data.dig 'message', 'title', 0 },
        publication:        lambda {|data| data.dig 'message', 'short-container-title', 0 },
        doi:                lambda {|data| self.id },
        pubmed_id:          lambda {|data| Pubmed.get_uid_from_doi(id) },
        published_at:       lambda do |data|
          if (date_parts = data.dig('message', 'published-print', 'date-parts', 0))
            year, month, day = date_parts

            return nil unless year

            date = "#{year}/#{month || 1}/#{day || 1}"
            Date.parse(date)
          end
        end,
        authors_attributes: lambda do |data|
          if (authors = data.dig 'message', 'author')
            authors.map do |author|
              {given_name: author['given'], family_name: author['family']}
            end
          else
            []
          end
        end,
        links_attributes:   lambda do |data|
          if (links = data.dig 'message', 'link')
            links.map {|link| Hash[url: link['URL'], link_editable: false] }
          else
            []
          end
        end
      }
    end
  end
end
