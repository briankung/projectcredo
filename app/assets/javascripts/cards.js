// THIS IS AWFUL
// SHAME TODO


$(document).ready(function() {
  $('div.panel-body').on('click', function(e) {
    target = $(e.target)

    if ( target.hasClass('panel-body')) {
      // I'm mixing jQuery and Javascript with the [0].click().
      // This is so that I can force clicking through to the URL of an <a> tag, which jQuery doesn't do.
      target.siblings('.card-link')[0].click();
    }

    return
  });
});