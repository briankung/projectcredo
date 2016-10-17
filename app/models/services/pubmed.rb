class Pubmed
  def initialize(options={})
    @base_url = 'http://eutils.ncbi.nlm.nih.gov'
    @search_url = @base_url + "/entrez/eutils/esearch.fcgi"
    @metadata_url = @base_url + "/entrez/eutils/esummary.fcgi"
    @abstract_url = @base_url + "/entrez/eutils/efetch.fcgi"
    @pubmed_scrape_url = 'https://www.ncbi.nlm.nih.gov/pubmed/'
    @pubmed_scrape_parameters = {
      report: 'xml',
      format: 'text'
    }
    @default_parameters = {
      db: 'pubmed',
      retmode: 'json',
      retmax: 20
    }
    @default_parameters = @default_parameters.merge options if options.any?
  end

  def search(query)
    metadata_uri = generate_uri(
      @metadata_url,
      @default_parameters.merge(id: get_search_result_ids(query).join(","))
    )

    JSON.parse Net::HTTP.get(metadata_uri)
  end

  def get_uid_metadata(uid)
    metadata_uri = generate_uri(
      @metadata_url,
      @default_parameters.merge(id: uid)
    )

    JSON.parse Net::HTTP.get(metadata_uri)
  end

  def get_abstract(uid)
    abstract_uri = generate_uri(@abstract_url, @default_parameters.merge(id: uid, retmode: 'xml'))
    response = Net::HTTP.get(abstract_uri)
    result = Hash.from_xml(response)
    abstract = result.dig(
      'PubmedArticleSet',
      'PubmedArticle',
      'MedlineCitation',
      'Article',
      'Abstract',
      'AbstractText'
    )
    if abstract.blank?
      uri = generate_uri(@pubmed_scrape_url + uid, @pubmed_scrape_parameters)
      response = Net::HTTP.get(uri)
      result = Hash.from_xml(response)
      if (pubmed_scrape = result.dig('pre'))
       abstract = pubmed_scrape[/#{"AbstractText"}(.*?)#{"</AbstractText>"}/m, 1].partition('>').last
      end
    end
    abstract = abstract.join ' ' if abstract.respond_to? :join

    return abstract
  end

  def import_paper identifier
    data = self.search(identifier)['result'][identifier]

    existing_authors, new_authors = [], []

    data['authors'].each do |author_data|
      if (author = Author.find_by name: author_data['name'])
        existing_authors << author
      else
        new_authors << {name: author_data['name']}
      end
    end

    paper = Paper.new(
      pubmed_id: data['uid'],
      title: data['title'],
      published_at: data['pubdate'],
      authors_attributes: new_authors,
      abstract: self.get_abstract(data['uid']),
      doi: data['elocationid'].sub(/^doi: /, ""),
      publication: data['source']
    )
    paper.authors.push *existing_authors unless existing_authors.empty?
    return paper
  end

  def get_search_result_ids query
    query = query.gsub(' ', '+')
    search_uri = generate_uri @search_url, @default_parameters.merge(term: query)
    search_response = JSON.parse Net::HTTP.get(search_uri)

    # Someday: It would be nice to validate that these search results are in the format we expect
    search_response['esearchresult']['idlist']
  end

  def find_uid_by_doi query
    search_uri = generate_uri @search_url, @default_parameters.merge(term: query)
    search_response = JSON.parse Net::HTTP.get(search_uri)
    search_response['esearchresult']['idlist'].first
  end

 def import_data_to_paper(paper,imported_data)
    if paper.authors.empty?
      names = imported_data['authors'].map {|a| a['name']}
      existing_authors = Author.where(name: names)
      existing_names = existing_authors.map(&:name)
      new_authors = (names - existing_names).map {|a| Author.create name: a}
    end

    articleids = imported_data['articleids']
    doi_hash = articleids.find {|id| id['idtype'] == 'doi' }

    if doi_hash
      doi = doi_hash['value']
    elsif imported_data['elocationid'].present?
      doi = imported_data['elocationid']
      doi = doi.sub(/.*?doi: /, "")
    else
      doi = nil
    end

    paper.pubmed_id ||= imported_data['uid']
    paper.title ||= imported_data['title']
    paper.published_at ||=  imported_data['pubdate']
    paper.authors ||= (existing_authors + new_authors)
    paper.abstract ||= Pubmed.new.get_abstract(imported_data['uid'])
    paper.doi ||= doi
    paper.publication ||= imported_data['source']

    return paper
  end

  private
    def generate_uri(url, parameters)
      URI.parse(url + '?' + URI.encode_www_form(parameters))
    end

end
