$(document).ready(function() {
  $('.paper-detail-tab').on('click', function(e) {
    e.preventDefault();

    var detailId = $(e.target).data("detail-id");

    paperDetail = $('#'+detailId);

    paperDetail.siblings('.paper-detail').each(function(i, sibling) {
      $(sibling).collapse('hide');
    });

    paperDetail.collapse('toggle');
  });
});