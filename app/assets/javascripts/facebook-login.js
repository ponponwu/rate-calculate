$(document).on('page:change', function (e) {
  if (window.location.hash && window.location.hash == '#_=_') {
    window.location.hash = '';
    history.pushState('', document.title, window.location.pathname); // nice and clean
    e.preventDefault(); // no page reloa
  }
});
