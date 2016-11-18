$(document).ready(function() {
  $(document).on('click', '.toggle-reply', function(e) {
    e.preventDefault();
    commentId = $(e.target).data('parent-comment-id');
    $("#comment-"+commentId+" > form").toggleClass('hidden');
  });

  $(document).on('click', '.cancel-comment-form', function(e) {
    e.preventDefault();
    commentContent = $(e.target).closest(".content");
    editLink = commentContent.siblings().find("a.edit-comment");
    editLink.parent('li').toggleClass('hidden', false);
    commentContent.html(commentContent.data("undo-form"));
  });

});
