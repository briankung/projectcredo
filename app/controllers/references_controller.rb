class ReferencesController < ApplicationController
  before_action :ensure_current_user, except: :show
  before_action :set_paper_locator, only: :create

  def show
    @reference = Reference.find(params[:id])
  end

  def create
    list = List.find(reference_params[:list_id])
    list_path = user_list_path(list.owner, list)

    unless list.accepts_public_contributions? || current_user.can_edit?(list)
      return redirect_back(fallback_location: list_path, alert: 'You must be a contributor to make changes to this list.')
    end

    return redirect_back(fallback_location: list_path, alert: @locator.errors.join(' ')) unless @locator.valid?

    if (paper = @locator.find_or_import_paper)
      if Reference.exists? list_id: list.id, paper_id: paper.id
        flash['notice'] = "'#{paper.title}' has already been added to this list"
      else
        Reference.create(list_id: list.id, paper_id: paper.id, user_id: current_user.id)
        flash['notice'] = "You added '#{paper.title}' to '#{list.name}'"
      end
    else
      logger.debug "No paper found for: #{paper_params.inspect}"
      flash['alert'] = "Couldn't find or import a paper with those parameters"
    end
    redirect_back(fallback_location: list_path)
  end

  def destroy
    reference = Reference.find(reference_params[:id])

    unless current_user.can_edit? reference.list
      return redirect_back(fallback_location: user_list_path(reference.list.owner, reference.list), alert: 'You must be a contributor to make changes to this list.')
    end

    reference.destroy

    respond_to do |format|
      format.html { redirect_to user_list_path(reference.list.owner, reference.list), notice: 'Reference was successfully destroyed.' }
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
      locator_type, locator_id, paper_title = paper_params.values_at(:locator_type, :locator_id, :title)

      return redirect_to(:back, alert: "Identifier can't be blank.") if locator_id.blank?

      case locator_type
      when 'doi'
        @locator = DoiPaperLocator.new locator_id: locator_id
      when 'link'
        @locator = LinkPaperLocator.new locator_id: locator_id, paper_title: paper_title
      when 'pubmed'
        @locator = PubmedPaperLocator.new locator_id: locator_id
      else
        return redirect_to(:back, alert: 'Bad locator parameters')
      end
    end
end
