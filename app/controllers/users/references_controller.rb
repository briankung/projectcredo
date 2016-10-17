class Users::ReferencesController < ApplicationController
  def show
    @user = User.find_by username: params[:username]
    @list = @user.lists.find_by slug: params[:list_slug]
    @reference = @list.references.find_by id: params[:reference_id]
    render 'references/show'
  end
end
