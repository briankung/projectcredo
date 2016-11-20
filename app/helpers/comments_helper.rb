module CommentsHelper
  def comments_tree_for(comments, list)
    comments.map do |comment, nested_comments|
      render 'comments/comment', comment: comment, list: list do
        content_tag(
          :div,
          comments_tree_for(nested_comments, list),
          class: "comments",
          'data-commentable-id' => comment.id
        )
      end
    end.join.html_safe
  end
end
