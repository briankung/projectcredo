module PapersHelper
  def tab_id_for paper
    paper.pubmed_id || paper.doi.gsub(/[^a-zA-Z]/, '') || paper.title.gsub(/[^a-zA-Z]/, '') || paper.created_at.to_i
  end
end
