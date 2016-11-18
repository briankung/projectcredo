class Lists::MembersController < ApplicationController
  before_action :ensure_current_user

  def destroy
    list = List.find params[:list_id]
    path = edit_user_list_path(list.user, list)
    current_membership = list.list_memberships.find_by user: current_user
    return unless current_membership

    member = User.find params[:id]
    removing_self = member == current_user

    unless current_membership.can_moderate? || removing_self
      return redirect_back(fallback_location: path, alert: 'You do not have permission to moderate this list')
    end

    list.members.delete member
    if removing_self
      return redirect_to(user_list_path(list.user, list), notice: "You have removed yourself from \"#{list.name}\"")
    else
      return redirect_back(fallback_location: path, notice: "\"#{member.username}\" is no longer a contributor")
    end
  end
end
