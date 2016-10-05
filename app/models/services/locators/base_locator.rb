class BaseLocator
  attr_accessor :column, :locator_id

  def initialize locator_id
    self.locator_id = locator_id.strip
  end

  def find_paper
    Paper.find_by self.column => self.locator_id
  end

  def import_data_to_paper(paper,imported_data,source)
    source = source.downcase

    if source == "pubmed"
      if paper.authors.empty?
        names = imported_data['authors'].map {|a| a['name']}
        existing_authors = Author.where(name: names)
        existing_names = existing_authors.map(&:name)
        new_authors = (names - existing_names).map {|a| Author.create name: a}
      end

      doi = imported_data['elocationid']
      if doi.blank?
        doi = imported_data['articleids'].find {|id| id['idtype'] == 'doi' }['value']
      end

      doi = doi.sub(/^doi: /, "")

      paper.pubmed_id ||= imported_data['uid']
      paper.title ||= imported_data['title']
      paper.published_at ||=  imported_data['pubdate']
      paper.authors ||= (existing_authors + new_authors)
      paper.abstract ||= Pubmed.new.get_abstract(imported_data['uid'])
      paper.doi ||= doi
      paper.publication ||= imported_data['source']
    end

    if source == "crossref"
      if paper.authors.empty?
        names = imported_data['author'].map {|a| "#{a['given']} #{a['family']}"}
        existing_authors = Author.where(name: names)
        existing_names = existing_authors.map(&:name)
        new_authors = (names - existing_names).map {|a| Author.create name: a}
      end

      paper.title ||= imported_data['title'].first
      paper.published_at ||=  imported_data['created']['date-time'].to_date
      paper.authors = (existing_authors + new_authors) if paper.authors.empty?
      paper.doi ||= imported_data['DOI']
      paper.publication ||= imported_data['publisher']
      paper.link ||= imported_data['link'].first['URL'] if imported_data['link']
    end

    return paper
  end
end