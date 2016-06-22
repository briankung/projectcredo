json.array!(@papers) do |paper|
  json.extract! paper, :id, :title, :published_at
  json.url paper_url(paper, format: :json)
end
