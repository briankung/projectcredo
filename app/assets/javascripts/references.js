$(document).ready(function() {
  $('a.delete-reference').on('click', function(e) {
    e.preventDefault();
    $(e.target).siblings('form').submit();
  });
});
