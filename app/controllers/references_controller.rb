class ReferencesController < ApplicationController
  before_action :ensure_current_user
  before_action :set_paper_locator, only: :create

  def create
    list = List.find(reference_params[:list_id])

    if (paper = @locator.find_paper)
      if Reference.exists? list_id: list.id, paper_id: paper.id
        flash['notice'] = 'This paper has already been added to this list'
      else
        Reference.create(list_id: list.id, paper_id: paper.id)
        flash['notice'] = "You added #{paper.title} to #{list.name}"
      end
    else
      flash['alert'] = "Couldn't find a paper with those parameters :'("
    end
    redirect_to list
  end

  def destroy
    if (reference = Reference.find_by(id: reference_params[:id]))
      reference.destroy
      redirect_to reference.list
    else
      redirect_to :back
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
      if paper_params.blank?
        flash['alert'] = 'Bad paper parameters'
        redirect_to :back
      elsif paper_params[:locator_type].blank? || paper_params[:locator_id].blank?
        flash['alert'] = 'Bad locator parameters'
        redirect_to :back
      end

      locator_type = paper_params.fetch :locator_type, nil
      locator_id = paper_params.fetch :locator_id, nil

      case locator_type
      when 'doi'
        @locator = DoiPaperLocator.new locator_id
      when 'link'
        if paper_params[:title].blank?
          flash['alert'] = 'You must enter a title'
          redirect_to :back
        end
        @locator = LinkPaperLocator.new locator_id, paper_params[:title]
      when 'pubmed'
        @locator = PubmedPaperLocator.new locator_id
      else
        flash['alert'] = 'Bad locator parameters'
        redirect_to :back
      end
    end
end
