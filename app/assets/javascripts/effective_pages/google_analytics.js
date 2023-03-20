// Add Google Analytics Code
// Supports Turbolinks and Turbo
document.addEventListener('turbolinks:load', function(event){
  if(typeof(gtag) != 'function') { return }

  var code = $('head').find('script[data-gtag-code]').first().data('gtag-code');
  if(typeof(code) == undefined) { return }

  gtag('config', code, {
    'page_title' : document.title,
    'page_path': location.href.replace(location.origin, "")
  });
})
