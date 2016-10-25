module ListParamsSortable
  extend ActiveSupport::Concern

  def params_sort_order
    pub_date_order = 'papers.published_at DESC NULLS LAST'
    vote_order = 'cached_votes_up DESC'

    if params[:sort] == 'pub_date'
      pub_date_order
    else # default to ordering by votes first, then pub date
      "#{vote_order}, #{pub_date_order}"
    end
  end
end
