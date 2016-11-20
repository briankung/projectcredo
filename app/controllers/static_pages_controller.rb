class StaticPagesController < ApplicationController
  def about
    @tutorial = List.find(1)
  end

end