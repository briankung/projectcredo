class PapersController < ApplicationController
  before_action :set_paper
  before_action :ensure_current_user, except: :show

  # GET /papers/1
  # GET /papers/1.json
  def show
  end

  # GET /papers/1/edit
  def edit
  end

  # PATCH/PUT /papers/1
  # PATCH/PUT /papers/1.json
  def update
    respond_to do |format|
      if @paper.update(paper_params)
        format.html { redirect_back(fallback_location: root_path, notice: 'Paper was successfully updated.') }
        format.json { render :show, status: :ok, location: @paper }
      else
        format.html { render :edit }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paper
      @paper = Paper.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paper_params
      params.require(:paper).permit(
        :title, :abstract, :link, :doi, :pubmed_id, :published_at, :publication,
        :tag_list, bias_list: [], methodology_list: [], authors_attributes: [:id, :name])
    end
end
