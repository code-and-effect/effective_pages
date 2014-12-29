initialize = ->
  $('.effective-menu').effectiveMenuEditor()

$ -> initialize()
$(document).on 'page:change', -> initialize()
