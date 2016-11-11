class ReferencesController < ApplicationController
  before_action :ensure_current_user, except: :show
  before_action :set_paper_locator, only: :create

  def show
    @reference = Reference.find(params[:id])
  end

  def create
    list = List.find(reference_params[:list_id])

    return redirect_to(:back, alert: 'Placeholder') unless @locator.valid?

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
    redirect_to :back
  end

  def destroy
    reference = Reference.find(reference_params[:id])
    reference.destroy

    respond_to do |format|
      format.html { redirect_to user_list_path(reference.list.user, reference.list), notice: 'Reference was successfully destroyed.' }
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

      return redirect_to(:back, alert: 'No parameters entered') if locator_id.blank?

      case locator_type
      when 'doi'
        @locator = DoiPaperLocator.new locator_id: locator_id
      when 'link'
        messages = []
        messages << 'You must enter a title.' if paper_title.blank?
        messages << "URL is invalid." unless locator_id =~ URI::regexp(%w{http https})
        return redirect_to(:back, alert: messages.join(' ')) if messages.any?
        @locator = LinkPaperLocator.new locator_id: locator_id, paper_title: paper_title
      when 'pubmed'
        @locator = PubmedPaperLocator.new locator_id: locator_id
      else
        return redirect_to(:back, alert: 'Bad locator parameters')
      end
    end
end
