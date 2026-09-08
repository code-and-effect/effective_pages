// Add Google Analytics Code
// Supports Turbolinks
document.addEventListener("turbolinks:load", function(event) {
  if(typeof(gtag) != 'function') { return }

  gtag('event', 'page_view', {
    page_title: event.target.title,
    page_location: event.data.url,
    page_path: location.href.replace(location.origin, "")
  });
})

// Supports Turbo
document.addEventListener("turbo:load", function(event) {
  if(typeof(gtag) != 'function') { return }

  gtag('event', 'page_view', {
    page_title: document.title,
    page_location: event.detail.url,
    page_path: location.href.replace(location.origin, "")
  });
})
