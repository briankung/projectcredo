class HomepageController < ApplicationController
  def show
    @lists = List.all
  end
end
