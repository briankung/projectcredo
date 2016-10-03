class DoiPaperLocator < BaseLocator
  def column
    'doi'
  end

  def find_paper
    return super if super

    pubmed = Pubmed.new
    if uid = pubmed.find_uid_by_doi(self.locator_id)
      results = pubmed.search(uid)
      data = results['result'][uid]
      names = data['authors'].map {|a| a['name']}

      existing_authors = Author.where(name: names)
      existing_names = existing_authors.map(&:name)
      new_authors = (names - existing_names).map {|a| Author.create name: a}

      paper = Paper.create(
        pubmed_id: data['uid'],
        title: data['title'],
        published_at: data['pubdate'],
        authors: (existing_authors + new_authors),
        abstract: pubmed.get_abstract(data['uid']),
        doi: data['elocationid'].sub(/^doi: /, ""),
        publication: data['source']
      )
      return paper
    else
      paper = Paper.new
      paper.errors.add(:locator_id, "is invalid; no paper found for searched DOI: #{self.locator_id}")
      return paper
    end
  end
end
