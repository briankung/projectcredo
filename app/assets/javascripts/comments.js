$(document).ready(function() {
  $('.toggle-reply').on('click', function(e) {
    e.preventDefault();
    $(e.target).parents("ul").next('.comment-reply').toggleClass('hidden');
  });

  $('[data-detail-id^=comments-]').each(function(index) {
    var commentCount = $('#comments-'+index ).find(".comment").length;
    $('[data-detail-id="comments-'+index+'"]').text("Comments(" + commentCount + ")");
  });
})