// Add Google Analytics Code
// Supports Turbolinks and Turbo
document.addEventListener("turbolinks:load", function(event) {
  if(typeof(gtag) != 'function') { return }

  gtag('event', 'page_view', {
    page_title: event.target.title,
    page_location: event.data.url,
    page_path: location.href.replace(location.origin, "")
  });
})
