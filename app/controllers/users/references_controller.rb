class Users::ReferencesController < ApplicationController
  before_action :set_user

  def show
    @list = @user.lists.find_by slug: params[:list_slug]
    @reference = @list.references.find_by id: params[:reference_id]
  end

  private
    def set_user
      @user = User.find_by username: params[:username]
    end
end
