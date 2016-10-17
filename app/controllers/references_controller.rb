class ReferencesController < ApplicationController
  before_action :ensure_current_user, except: :show
  before_action :set_paper_locator, only: :create

  def show
    @reference = Reference.find(params[:id])
  end

  def create
    list = List.find(reference_params[:list_id])
    paper = @locator.find_paper

    if paper.persisted?
      if Reference.exists? list_id: list.id, paper_id: paper.id
        flash['notice'] = 'This paper has already been added to this list'
      else
        Reference.create(list_id: list.id, paper_id: paper.id)
        flash['notice'] = "You added '#{paper.title}' to '#{list.name}'"
      end
    else

      flash['alert'] = paper.errors.map {|e,msg| "#{e.to_s.humanize.gsub('Links.url','URL')} #{msg}."}.join(', ')
    end
    redirect_to list
  end

  def destroy
    reference = Reference.find(reference_params[:id])
    reference.destroy

    respond_to do |format|
      format.html { redirect_to reference.list, notice: 'Reference was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def reference_params
      params.require(:reference).permit(
        :list_id, :paper_id, :id, paper: [:locator_id, :locator_type, :title])
    end

    def paper_params
      reference_params.fetch(:paper, nil)
    end

    def set_paper_locator
      if paper_params[:locator_id].blank?
        flash['alert'] = 'No parameters entered'
        redirect_to :back
      elsif paper_params[:locator_type] == 'link'
        messages = []
        messages << 'You must enter a title.' if paper_params[:title].blank?
        messages << "URL is invalid." unless paper_params[:locator_id] =~ URI::regexp(%w(http https))
        flash['alert'] = messages.join(" ")
        redirect_to :back
      end

      locator_type = paper_params.fetch :locator_type, nil
      locator_id = paper_params.fetch :locator_id, nil

      case locator_type
      when 'doi'
        @locator = DoiPaperLocator.new locator_id
      when 'link'
        @locator = LinkPaperLocator.new locator_id, paper_params[:title]
      when 'pubmed'
        @locator = PubmedPaperLocator.new locator_id
      else
        flash['alert'] = 'Bad locator parameters'
        redirect_to :back
      end
    end
end
