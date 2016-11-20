class StaticPagesController < ApplicationController
  def about
    @tutorial = List.first
  end

end
