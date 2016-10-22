$(document).ready(function() {
  var resultsElement = $('#crossref-results');

  var hideResults = function() {
    resultsElement.toggleClass('hidden', true);
    resultsElement.children().remove();
  }

  var hideResultsAndClearSubmittable = function() {
    hideResults();
    $('.crossref').toggleClass('submittable', false);
    $('#crossref-locator-id').val('');
  }

  var showCrossrefResults = debounce(function() {
    if (this.value === '') {
      hideResultsAndClearSubmittable();
    } else {
      $.get('https://search.crossref.org/dois?sort=score&q=' + this.value).done(function(data) {
        var results;

        if (data.length > 0) {
          resultsElement.children().remove();

          results = data.map(function(result) {
            return '<li class="list-group-item" data-doi="' + result.doi.replace('http://dx.doi.org/', '') + '">' + result.fullCitation + "</li>"
          });
          resultsElement.append(results.join(''));
          resultsElement.toggleClass('hidden', false);
        } else {
          hideResultsAndClearSubmittable();
        };
      })
    }
  }, 200);

  $(document).on('click', '#crossref-results .list-group-item', function(e) {
    $('#crossref-search').val(this.innerText);
    $('#crossref-locator-id').val(this.dataset.doi);
    $('.crossref').toggleClass('submittable', true);
    hideResults();
  });

  $('#crossref-search').on('input', showCrossrefResults);
  $('#crossref-search').on('input', hideResultsAndClearSubmittable);
  $('#crossref-search').on('keydown', function (e) {
    if (e.keyCode === 27) {
      this.value = '';
      hideResultsAndClearSubmittable();
    };
  });

  $('#crossref-submit').on('click', function(e) {
    if ($(this).parent().hasClass('submittable')) {
      $(this).siblings('form#new_reference').submit();
    }
  });

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
