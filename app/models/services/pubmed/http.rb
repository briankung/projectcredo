class Pubmed
  class Http
    def self.default_parameters
      {
        db: 'pubmed',
        retmode: 'xml',
        retmax: 20
      }
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
      URI.parse("https://eutils.ncbi.nlm.nih.gov#{url}?" + URI.encode_www_form(parameters))
    end
  end
end
