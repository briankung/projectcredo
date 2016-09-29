$(document).ready(function() {
  $('.toggle-reply').on('click', function(e) {
    e.preventDefault();
    $(e.target).parents("ul").next('.comment-reply').toggleClass('hidden');
  });
});


$(document).ready(function() {
    $( '[data-detail-id^=comments-]' ).each(function(index) {
      var comments = $( '#comments-'+index ).find(".comment").length;
      $( '[data-detail-id="comments-'+index+'"]').text( "Comments(" + comments + ")" );
    });
  })