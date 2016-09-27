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
      if (!paperLocator.hasClass('hidden')) { paperLocator.addClass('hidden'); };
      if (!paperLocator.prop('disabled')) { paperLocator.prop('disabled', true); };

      if (!paperTitle.hasClass('hidden')) { paperTitle.addClass('hidden'); };
      if (!paperTitle.prop('disabled')) { paperTitle.prop('disabled', true); };
    } else if (this.value === 'link') {
      // When link selected, expose locator and paper title field
      if (paperLocator.hasClass('hidden')) { paperLocator.removeClass('hidden'); };
      if (paperLocator.prop('disabled')) { paperLocator.prop('disabled', false); };

      if (paperTitle.hasClass('hidden')) { paperTitle.removeClass('hidden'); };
      if (paperTitle.prop('disabled')) { paperTitle.prop('disabled', false); };
    } else {
      // When not blank and not link, expose locator field and hide the paper title field
      if (paperLocator.hasClass('hidden')) { paperLocator.removeClass('hidden'); };
      if (paperLocator.prop('disabled')) { paperLocator.prop('disabled', false); };

      if (!paperTitle.hasClass('hidden')) { paperTitle.addClass('hidden'); };
      if (!paperTitle.prop('disabled')) { paperTitle.prop('disabled', true); };
    };
  });
});
