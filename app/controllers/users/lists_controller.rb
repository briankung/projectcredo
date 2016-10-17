class Users::ListsController < ApplicationController
  def index
    @user = User.find_by username: params[:id]
    @lists = @user.lists
    render 'lists/index'
  end

  def show
    @list = List.find_by slug: params[:id]
    @references = @list.references
    render 'lists/show'
  end
end
