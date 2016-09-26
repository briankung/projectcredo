module CommentsHelper
  def comments_tree_for(comments)
    comments.sort_by{ |k,v| v[:cached_vote_up] }.map do |comment, nested_comments|
      render(comment) do
        content_tag(:div, comments_tree_for(nested_comments), class: 'reply') if nested_comments.size > 0
      end
    end.join.html_safe
  end
end