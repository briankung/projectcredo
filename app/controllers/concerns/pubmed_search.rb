module PubmedSearch
  extend ActiveSupport::Concern

  def search_pubmed(search_term)
    @search_term = search_term.split.join("+")
    search_url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmode=json&retmax=20&term='+@search_term
    search_uri = URI.parse(search_url)
    search_response = Net::HTTP.get(search_uri)
    uids = JSON.parse(search_response)['esearchresult']['idlist'].map {|uid| uid}.join(",")


    metadata_url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&retmode=json&rettype=abstract&id='+uids
    uri = URI.parse(metadata_url)
    response = Net::HTTP.get(uri)
    @results = JSON.parse(response)
  end
end