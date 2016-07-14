class HomepageController < ApplicationController  
  include PubmedSearch

  def show
    if current_user
      @lists = current_user.homepage.lists
      if params[:search_term]
        search_pubmed(params[:search_term])
      end  
    else
      redirect_to lists_url
    end
  end
end
