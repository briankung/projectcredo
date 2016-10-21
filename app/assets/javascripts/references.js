$(document).ready(function() {
  $('a.delete-reference').on('click', function(e) {
    e.preventDefault();
    $(e.target).siblings('form').submit();
  });

  $('.add-paper select').on('change', function() {
    paperLocator = $(this).siblings('.paper-locator');
    paperTitle = $(this).siblings('.paper-title');

    if (this.value === '') {
      // When no selection made, hide the locator and the paper title fields
      paperLocator.toggleClass('hidden', true)
      if (!paperLocator.prop('disabled')) { paperLocator.prop('disabled', true); };

      paperTitle.toggleClass('hidden', true)
      if (!paperTitle.prop('disabled')) { paperTitle.prop('disabled', true); };
    } else if (this.value === 'link') {
      // When link selected, expose locator and paper title field
      paperLocator.toggleClass('hidden', false)
      if (paperLocator.prop('disabled')) { paperLocator.prop('disabled', false); };

      paperTitle.toggleClass('hidden', false)
      if (paperTitle.prop('disabled')) { paperTitle.prop('disabled', false); };
    } else {
      // When not blank and not link, expose locator field and hide the paper title field
      paperLocator.toggleClass('hidden', false)
      if (paperLocator.prop('disabled')) { paperLocator.prop('disabled', false); };

      paperTitle.toggleClass('hidden', true)
      if (!paperTitle.prop('disabled')) { paperTitle.prop('disabled', true); };
    };
  });
});
