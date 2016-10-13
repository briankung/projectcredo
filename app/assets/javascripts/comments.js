$(document).ready(function() {
  $('.toggle-reply').on('click', function(e) {
    e.preventDefault();
    $(e.target).parents("ul").next('.comment-reply').toggleClass('hidden');
  });
})