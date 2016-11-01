module CommentsHelper
  def comments_tree_for(comments)
    comments.map do |comment, nested_comments|
      render 'comments/comment', comment: comment do
        content_tag(
          :div,
          comments_tree_for(nested_comments),
          id: "child-comments-#{comment.id}"
        )
      end
    end.join.html_safe
  end
end
