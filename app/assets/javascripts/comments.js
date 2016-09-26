$(document).ready(function() {
  $('.toggle-reply').on('click', function(e) {
    e.preventDefault();
    $(e.target).next('.comment-reply').toggleClass('hidden');
  });
});