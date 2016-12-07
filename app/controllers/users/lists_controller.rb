class Users::ListsController < ApplicationController
  before_action :ensure_current_user, except: [:index, :show]
  before_action :set_user
  before_action :set_list, except: :index
  before_action :ensure_editable, only: [:edit, :update]
  before_action :ensure_visible, only: :show

  def index
    @lists = @user.authored_lists.distinct
  end

  def show
    @references = @list.references.joins(:paper).order(params_sort_order)
  end

  def edit
  end

  def update
    member = User.find_by username: params[:list].delete(:members)
    params[:list].delete(:participants) unless current_user == @list.owner

    if member && current_user.can_moderate?(@list)
      @list.list_memberships.build(user: member, role: :contributor)
    end

    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_back(fallback_location: user_list_path(@list.user, @list), notice: 'List was successfully updated.') }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless current_user == @list.owner
      return redirect_back(fallback_location: root_path, alert: 'Only the list owner can delete a list.')
    end

    @list.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find_by 'LOWER(username) = ?', params[:username].downcase
    end

    def set_list
      @list = @user.owned_lists.find_by slug: params[:id]
      return redirect_back(fallback_location: root_path, alert: "List not found.") unless @list
    end

    def params_sort_order
      if params[:sort] == 'pub_date'
        'papers.published_at DESC NULLS LAST'
      else # default to ordering by votes first, then create date
        "cached_votes_up DESC, created_at ASC"
      end
    end

    def list_params
      params.require(:list).permit(:name, :description, :tag_list, :members, :participants)
    end

    def ensure_editable
      redirect_to(root_path) unless current_user

      unless current_user.can_edit? @list
        return redirect_back(
          fallback_location: root_path,
          alert: 'You must be a contributor to make changes to this list.'
        )
      end
    end

    def ensure_visible
      return if @list.visible_to_public?
      return redirect_back(fallback_location: root_path) unless current_user && current_user.can_view?(@list)
    end
end
