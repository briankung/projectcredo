module PubmedSearch
  extend ActiveSupport::Concern

  def search_pubmed(search_term)
    @search_terms = search_term.split.join("+")
    search_url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmode=json&retmax=20&term='+@search_terms
    puts search_url
    uri = URI.parse(search_url)
    response = Net::HTTP.get(uri)
    @search_results = JSON.parse(response) 
    
  end
end