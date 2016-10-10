class DoiPaperLocator < BaseLocator
  def column
    'doi'
  end

  def find_paper
    return super if super

    paper = Paper.new

    crossref = Crossref.new
    result = crossref.get_doi_metadata(self.locator_id)
    if result[:error]
      data = result['message']
      paper = self.import_data_to_paper(paper,data,'crossref')
    end

    pubmed = Pubmed.new
    if (uid = pubmed.find_uid_by_doi(self.locator_id))
      result = pubmed.get_uid_metadata(uid)
      data = result['result'][uid]
      paper = self.import_data_to_paper(paper,data,'pubmed')
    end

    existing_paper = Paper.where( "title = ? or pubmed_id = ? and pubmed_id is not null", paper.title, paper.pubmed_id ).first

    if existing_paper.present?
      return existing_paper
    elsif paper.save
      return paper
    else
      paper.errors.delete(:title)
      paper.errors.add(:locator_id, "is invalid; no paper found for searched DOI: #{self.locator_id}")
      return paper
    end

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
      if paper.authors.empty? && imported_data['author']
        names = imported_data['author'].map {|a| "#{a['given']} #{a['family']}"}
        existing_authors = Author.where(name: names)
        existing_names = existing_authors.map(&:name)
        new_authors = (names - existing_names).map {|a| Author.create name: a}
        paper.authors = (existing_authors + new_authors)
      end

      paper.title ||= imported_data['title'].first
      paper.published_at ||=  imported_data['created']['date-time'].to_date
      paper.doi ||= imported_data['DOI']
      paper.publication ||= imported_data['publisher']
      paper.link ||= imported_data['link'].first['URL'] if imported_data['link']
    end

    return paper
  end

end
