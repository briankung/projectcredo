json.array!(@papers) do |paper|
  json.extract! paper, :id, :title, :abstract, :link, :doi, :pubmed_id, :published_at
  json.url paper_url(paper, format: :json)
end
