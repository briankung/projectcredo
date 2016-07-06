class HomepageController < ApplicationController
  def show
    if current_user
      @lists = current_user.homepage.lists
    else
      @lists = List.all
    end
  end
end
