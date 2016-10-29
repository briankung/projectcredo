$(document).ready(function() {
  $(document).on('click', '.toggle-reply', function(e) {
    e.preventDefault();
    commentID = $(e.target).data('parent-comment-id');
    $("#reply-form-"+commentID).toggleClass('hidden');
  });
});
