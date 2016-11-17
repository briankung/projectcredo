class ListsController < ApplicationController
  before_action :ensure_current_user, except: [:index]

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.all
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = current_user.lists.build(list_params)

    respond_to do |format|
      if @list.save
        current_user.homepage.lists << @list
        format.html { redirect_to user_list_path(@list.user, @list), notice: 'List was successfully created.' }
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
