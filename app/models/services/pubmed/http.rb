class Pubmed
  class Http
    def self.default_parameters
      {
        db: 'pubmed',
        retmode: 'xml',
        retmax: 20,
        tool: 'projectcredo',
        email: 'accounts'
      }
    end

    def self.esearch params = {}
      get_response "/entrez/eutils/esearch.fcgi", params
    end

    def self.esummary params = {}
      get_response "/entrez/eutils/esummary.fcgi", params
    end

    def self.efetch params = {}
      get_response "/entrez/eutils/efetch.fcgi", params
    end

    def self.idconv params = {}
      get_response "/pmc/utils/idconv/v1.0/", params
    end

    def self.get_response(path, parameters)
      uri = URI.parse("https://eutils.ncbi.nlm.nih.gov#{path}?" + URI.encode_www_form(default_parameters.merge parameters))

      Net::HTTP.get_response(uri)
    end
  end
end
