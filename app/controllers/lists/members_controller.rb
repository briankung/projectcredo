class Lists::MembersController < ApplicationController
  before_action :ensure_current_user

  def create
    list = List.find params[:list_id]
    member = User.find params[:id]
    list.members.add member, role: :contributor
    return redirect_back(fallback_location: edit_user_list_path(list.user, list))
  end

  def destroy
    list = List.find params[:list_id]
    member = User.find params[:id]
    list.members.delete member
    return redirect_back(fallback_location: edit_user_list_path(list.user, list))
  end
end
