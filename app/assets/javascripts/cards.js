// THIS IS AWFUL
// SHAME TODO


$(document).ready(function() {
  $('div.panel-body').on('click', function(e) {
    target = $(e.target)

    // I'm whitelisting .col-md-12 as a child node of div.panel-body that can act as a clickable link.
    // This is very brittle.
    if (target.hasClass('col-md-12')) {
      panel = target.closest('.panel-body');
      // I'm mixing jQuery and Javascript with the [0].click().
      // This is so that I can force clicking through to the URL of an <a> tag, which jQuery doesn't do.
      panel.siblings('.card-link')[0].click();
    } else if ( target.hasClass('panel-body')) {
      target.siblings('.card-link')[0].click();
    }

    return
  });
});