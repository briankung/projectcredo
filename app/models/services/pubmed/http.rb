class Pubmed
  class Http
    def self.default_params
      {
        db: 'pubmed',
        retmode: 'xml',
        retmax: 20,
        tool: 'projectcredo',
        email: 'accounts'
      }
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

    def self.idconv params = {}
      get_response "https://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0/", params
    end

    def self.get_response(path, params)
      uri = URI.parse("#{path}?" + URI.encode_www_form(default_params.merge params))

      Net::HTTP.get_response(uri)
    end
  end
end
