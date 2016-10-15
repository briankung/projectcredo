class Crossref
  def initialize(options={})
    @base_url = 'http://api.crossref.org/'
    @metadata_url = @base_url + "works/"
    @funder_url = @base_url + "funders/"
  end

  def get_doi_metadata(doi)
    metadata_uri = URI.parse(@metadata_url+doi)
    if Net::HTTP.get_response(metadata_uri).is_a?(Net::HTTPSuccess)
      JSON.parse(Net::HTTP.get(metadata_uri))
    else
      return {error: 'no paper found in CrossRef'}
    end
  end

  def import_data_to_paper(paper,imported_data)
    if paper.authors.empty? && imported_data['author']
      names = imported_data['author'].map {|a| "#{a['given']} #{a['family']}"}
      existing_authors = Author.where(name: names)
      existing_names = existing_authors.map(&:name)
      new_authors = (names - existing_names).map {|a| Author.create name: a}
      paper.authors = (existing_authors + new_authors)
    end
    if paper.links.empty? && imported_data['link']
      links = imported_data['link'].map do |link|
        Link.create( url: link['URL'] )
      end
      paper.links = links
    end
    paper.title ||= imported_data['title'].first
    paper.published_at ||=  imported_data['created']['date-time'].to_date
    paper.doi ||= imported_data['DOI']
    paper.publication ||= imported_data['publisher']
    paper.links ||= imported_data['link'].first['URL'] if imported_data['link']

    return paper
  end
end
