$(document).ready(function() {
  $('.toggle-reply').on('click', function(e) {
    e.preventDefault();
    var toggleHideId = $(e.target).data("toggle-hide-id")
    $('#'+toggleHideId).toggleClass('hidden');
  });
});