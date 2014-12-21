initialize = ->
  menu = $('.effective-menu')
  return if menu.data('effective-menu-initialized') == true

  # Prevent the menu from actually working
  menu.on 'click', 'a', (event) -> event.preventDefault()

  draggable = null

  menu.on 'dragstart', 'li', (event) ->
    obj = $(event.currentTarget)
    event.originalEvent.dataTransfer.setData('text/html', obj[0].outerHTML)
    obj.css('opacity', '0.5') # Show it slightly removed from the DOM
    draggable = obj
    event.stopPropagation()

  menu.on 'dragenter', 'li', (event) -> event.preventDefault() # enable drag and drop
  menu.on 'dragleave', 'li', (event) -> event.preventDefault() # enable drag and drop

  menu.on 'dragover', 'li', (event) ->
    node = $(this)

    if node.hasClass('dropdown') && !node.hasClass('open') # This is a menu, expand it
      node.siblings().removeClass('open') # menu.find('.open').removeClass('open')
      node.addClass('open')
    else
      event.preventDefault()

    # If I don't have the placeholder class already
    if node.hasClass('placeholder') == false
      menu.find('.placeholder').removeClass('placeholder')
      node.addClass('placeholder')

    event.stopPropagation() # fix on the child LI

  menu.on 'drop', 'li', (event) ->
    $(event.currentTarget).before(event.originalEvent.dataTransfer.getData('text/html'))
    menu.find('.placeholder').removeClass('placeholder')

    draggable.remove() if draggable

    event.stopPropagation()
    event.preventDefault()

  # All Done
  menu.data('effective-menu-initialized', true)

$ -> initialize()
$(document).on 'page:change', -> initialize()
