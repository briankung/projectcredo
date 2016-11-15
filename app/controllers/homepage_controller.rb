class HomepageController < ApplicationController
  def show
    if current_user
      @pinned_lists = current_user.homepage.lists
      @unpinned_lists = current_user.visible_lists.where.not(id: @pinned_lists.pluck(:id)).limit(9)
    else
      redirect_to lists_url
    end
  end
end
