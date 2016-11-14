class Users::ListsController < ApplicationController
  before_action :set_user

  def edit
    @list = @user.lists.find_by slug: params[:id]
    render 'lists/edit'
  end

  def index
    @lists = @user.lists.default_sort
    render 'lists/index'
  end

  def show
    @list = @user.lists.find_by slug: params[:id]
    @references = @list.references.joins(:paper).order(params_sort_order)
    render 'lists/show'
  end

  private
    def set_user
      @user = User.find_by username: params[:username]
    end

    def params_sort_order
      if params[:sort] == 'pub_date'
        'papers.published_at DESC NULLS LAST'
      else # default to ordering by votes first, then create date
        "cached_votes_up DESC, created_at ASC"
      end
    end
end
