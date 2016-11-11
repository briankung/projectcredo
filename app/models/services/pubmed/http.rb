class Pubmed
  class Http
    def self.eutils_params
      {
        db: 'pubmed',
        retmode: 'xml',
        retmax: 20
      }
    end

    def self.id_params
      {
        tool: 'projectcredo',
        email: 'accounts@projectcredo.com'
      }
    end

    def self.default_params
      id_params.merge eutils_params
    end

    def self.esearch params = {}
      get_response "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi", params
    end

    def self.esummary params = {}
      get_response "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi", params
    end

    def self.efetch params = {}
      get_response "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi", params
    end

    def self.get_response(url, params)
      uri = URI.parse(url + "?" + URI.encode_www_form(default_params.merge params))
      Net::HTTP.get_response(uri)
    end
  end
end
