class PubmedPaperLocator < BaseLocator
  def column
    'pubmed_id'
  end

  def find_paper
    return super if super

    pubmed = Pubmed.new
    result = pubmed.get_uid_metadata(self.locator_id)
    if (data = result['result'][self.locator_id])
      names = data['authors'].map {|a| a['name']}

      existing_authors = Author.where(name: names)
      existing_names = existing_authors.map(&:name)
      new_authors = (names - existing_names).map {|a| Author.create name: a}

      doi = data['elocationid']
      if doi.blank?
        doi = data['articleids'].find {|id| id['idtype'] == 'doi' }['value']
      end

      doi = doi.sub(/^doi: /, "")

      paper = Paper.create(
        pubmed_id: data['uid'],
        title: data['title'],
        published_at: data['pubdate'],
        authors: (existing_authors + new_authors),
        abstract: pubmed.get_abstract(data['uid']),
        doi: doi,
        publication: data['source']
      )
      return paper
    else
      paper = Paper.new
      paper.errors.add(:locator_id, "is invalid; no paper found for searched Pubmed ID: #{self.locator_id}")
      return paper
    end

  end
end