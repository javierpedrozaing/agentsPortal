document.addEventListener('turbolinks:click', function() {
  $('#loading-spinner').show();
});

document.addEventListener('turbolinks:load', function() {
  $('#loading-spinner').hide();
});
