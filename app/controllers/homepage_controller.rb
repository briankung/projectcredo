class HomepageController < ApplicationController
  def show
    if current_user
      @lists = current_user.homepage.lists
    else
      redirect_to lists_url
    end

    @results = Pubmed.new.search(params[:search_term]) if params[:search_term].present?
  end
end
