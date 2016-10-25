class Users::ListsController < ApplicationController
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

    def params_sort_order
      pub_date_order = 'papers.published_at DESC NULLS LAST'
      vote_order = 'cached_votes_up DESC'

      if params[:sort] == 'pub_date'
        pub_date_order
      else # default to ordering by votes first, then pub date
        "#{vote_order}, #{pub_date_order}"
      end
    end
end
