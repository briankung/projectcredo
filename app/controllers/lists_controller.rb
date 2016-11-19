class ListsController < ApplicationController
  before_action :ensure_current_user, except: [:index]

  # GET /lists
  # GET /lists.json
  def index
    if current_user
      @lists = current_user.visible_lists
    else
      @lists = List.publicly_visible
    end
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = current_user.lists.build(list_params)
    member = User.find_by username: params[:list].delete(:members)

    respond_to do |format|
      if @list.save
        @list.members.add(member, role: :contributor) if member
        current_user.homepage.lists << @list
        format.html { redirect_to user_list_path(@list.owner, @list), notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :description, :tag_list)
    end
end
