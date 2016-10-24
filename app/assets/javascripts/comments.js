$(document).ready(function() {
  $(document).on('click', '.toggle-reply', function(e) {
    e.preventDefault();
    commentID = $(e.target).data('parent-comment-id');
    $(e.target).parents("ul").next("#reply-"+commentID).toggleClass('hidden');
  });
});
