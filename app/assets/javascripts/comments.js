$(document).ready(function() {
  $(document).on('click', '.toggle-reply', function(e) {
    e.preventDefault();
    commentId = $(e.target).data('parent-comment-id');
    $("#comment-"+commentId+" > form").toggleClass('hidden');
  });
});
