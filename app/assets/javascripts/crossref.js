$(document).ready(function() {
  var resultsElement = $('#crossref-results');

  var hideResults = function() {
    resultsElement.toggleClass('hidden', true);
    resultsElement.children().remove();
  }

  var hideResultsAndClearSearchValue = function() {
    hideResults();
    $('#crossref-locator-id').val('');
  }

  var showCrossrefResults = debounce(function() {
    if (this.value === '') {
      hideResultsAndClearSearchValue();
    } else {
      $.get('https://search.crossref.org/dois?sort=score&type=Journal+Article&rows=10&q=' + this.value).done(function(data) {
        var results;

        resultsElement.children().remove();

        if (data.length > 0) {
          results = data.map(function(result) {
            return '<li class="clickable list-group-item" data-doi="' + result.doi.replace('http://dx.doi.org/', '') + '">' + result.fullCitation + "</li>"
          });
          resultsElement.append(results.join(''));
        } else {
          resultsElement.append('<li class="list-group-item">No search results found.</li>');
        };

        resultsElement.toggleClass('hidden', false);
      })
    }
  }, 200);

  $(document).on('click', '#crossref-results .list-group-item', function(e) {
    var clickable = $(this).hasClass('clickable');
    if (!clickable) {
      hideResultsAndClearSearchValue();
      $('#crossref-search').val('');
      $('#crossref-search').focus();
      return;
    };
    $('#crossref-search').val(this.innerText);
    $('#crossref-locator-id').val(this.dataset.doi);
    $('#crossref-search').toggleClass('submitted', true);
    $('.crossref form#new_reference').submit()
    hideResults();
  });

  $('#crossref-search').on('input', showCrossrefResults);
  $('#crossref-search').on('input', hideResultsAndClearSearchValue);
  $('#crossref-search').on('keydown', function (e) {
    if (e.keyCode === 27) {
      this.value = '';
      hideResultsAndClearSearchValue();
    };
  });
});
