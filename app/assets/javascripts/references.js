$(document).ready(function() {
  var showCrossrefResults = debounce(function() {
    var resultsElement = $('#crossref-results');

    var hideResults = function() {
      resultsElement.toggleClass('hidden', true);
      resultsElement.children().remove();
    }

    if (this.value === '') {
      hideResults();
    } else {
      $.get('https://search.crossref.org/dois?sort=score&q=' + this.value).done(function(data) {
        var results, resultsByFullCitation;
        resultsByFullCitation = {}

        if (data.length > 0) {
          var citations;

          data.forEach(function(datum) {
            var caseSensitiveCitation;
            caseSensitiveCitation = datum.fullCitation || datum.title;
            resultsByFullCitation[datum.fullCitation.toLowerCase()] = datum.fullCitation || datum.title;
          });

          resultsElement.children().remove();
          results = $.map(resultsByFullCitation, function(citation) {return "<li class='list-group-item'>" + citation + "</li>"});
          resultsElement.append(results.join(''));
          resultsElement.toggleClass('hidden', false);
        } else {
          hideResults();
        };
      })
    }
  }, 200);

  $('#crossref-search').on('input', showCrossrefResults);
  $('#crossref-search-form').on('submit', function(e) {e.preventDefault()});
  $('#crossref-search-form input.btn').on('click', function(e) {e.preventDefault()});

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
