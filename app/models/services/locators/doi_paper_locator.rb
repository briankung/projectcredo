class DoiPaperLocator < BaseLocator
  def column
    'doi'
  end

  def find_paper
    return super if super

    pubmed = Pubmed.new
    if uid = pubmed.get_search_result_ids(self.locator_id)
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
      return Paper.new
    end
  end
end
