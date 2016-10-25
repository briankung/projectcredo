class Users::ListsController < ApplicationController
  include ListParamsSortable

  before_action :set_user

  def index
    @lists = @user.lists
    render 'lists/index'
  end

  def show
    @list = @user.lists.find_by slug: params[:list_slug]
    @references = @list.references.joins(:paper).order(params_sort_order)
    render 'lists/show'
  end

  private
    def set_user
      @user = User.find_by username: params[:username]
    end
end
