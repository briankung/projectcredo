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
