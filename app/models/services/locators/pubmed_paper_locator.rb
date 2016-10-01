class PubmedPaperLocator < BaseLocator
  def column
    'pubmed_id'
  end

  def find_paper
    return super if super

    pubmed = Pubmed.new
    results = pubmed.search(self.locator_id)
    data = results['result'][self.locator_id]
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
  end
end