class Pubmed
  class Core
    def self.get_search_result_ids term: , retmode: 'xml'
      term = term.gsub(/\s/, '+')
      response = Pubmed::Http.esearch(term: term)
      parse_and_fetch(
        content: response.body,
        retmode: retmode,
        xml_path: ['eSearchResult', 'IdList']
      )
    end

    def self.get_summaries uids, retmode: 'xml'
      Pubmed::Http.esummary(id: uids.join(','), retmode: retmode)
    end

    def self.search query, retmode: 'xml'
      Pubmed::Core.get_summaries get_search_result_ids(query), retmode: retmode
    end

    def self.get_uid_from_doi doi, retmode: 'xml'
      response = Pubmed::Http.esearch(term: doi)

      doi_not_found = parse_and_fetch(
        content: response.body,
        retmode: retmode,
        xml_path: ["eSearchResult", "ErrorList", "PhraseNotFound"]
      )

      uid = parse_and_fetch(
        content: response.body,
        retmode: retmode,
        xml_path: ['eSearchResult', 'IdList', 0]
      )

      if doi_not_found
        return nil
      else
        return uid
      end
    end

    def self.get_details(uid)
      return nil if uid.nil?
      Pubmed::Http.efetch(id: uid)
    end

    def self.get_details_from_doi(doi)
      return nil if doi.nil?

      uid = Pubmed::Core.get_uid_from_doi(doi)
      Pubmed::Http.efetch(id: uid)
    end

    def self.parse content: , retmode: 'xml'
      if retmode == 'xml'
        Hash.from_xml content
      elsif retmode == 'json'
        JSON.parse content
      end
    end

    def self.parse_and_fetch content: , retmode: , xml_path:
      parsed = parse(content: content, retmode: retmode)
      if retmode == 'xml'
        parsed.dig *xml_path
      elsif retmode == 'json'
        parsed.dig *xml_path.map(&:downcase)
      end
    end
  end
end
