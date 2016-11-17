class Users::ReferencesController < ApplicationController
  def show
    user = User.find_by username: params[:username]
    list = user.lists.find_by slug: params[:user_list_id]

    @reference = list.references.find_by id: params[:id]
    render 'references/show'
  end
end
