json.array!(@papers) do |paper|
  json.extract! paper, :id, :title, :published_at, :journal
  json.url paper_url(paper, format: :json)
end
