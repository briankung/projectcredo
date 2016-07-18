class HomepageController < ApplicationController  
  include PubmedSearch

  def show
    if current_user
      @lists = current_user.homepage.lists 
    else
      redirect_to lists_url
    end

    if params[:search_term].present?
      search_pubmed(params[:search_term])
    end 
  end
end
