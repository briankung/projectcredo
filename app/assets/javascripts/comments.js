$(document).ready(function() {
  $(document).on('click', '.toggle-reply', function(e) {
    e.preventDefault();
    commentId = $(e.target).data('parent-comment-id');
    $("#reply-form-"+commentId).toggleClass('hidden');
  });
});
