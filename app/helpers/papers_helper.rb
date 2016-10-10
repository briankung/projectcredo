module PapersHelper
  def tab_id_for paper
    paper.pubmed_id ||
    paper.doi.try(:gsub, /[^a-zA-Z]/, '') ||
    paper.title.try(:gsub, /[^a-zA-Z]/, '') ||
    paper.created_at.to_i
  end
end
