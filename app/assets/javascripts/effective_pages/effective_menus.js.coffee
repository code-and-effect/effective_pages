initialize = ->
  menu = $('.effective-menu')
  return if menu.data('effective-menu-initialized') == true

  # Prevent the menu from actually working
  menu.on 'click', 'a', (event) -> event.preventDefault()

  draggable = null

  menu.on 'dragstart', 'li', (event) ->
    node = $(event.currentTarget)
    event.originalEvent.dataTransfer.setData('text/html', node[0].outerHTML)

    node.css('opacity', '0.4') # Show it slightly removed from the DOM
    menu.addClass('dragging')

    draggable = node

    event.stopPropagation()

  menu.on 'dragenter', 'li', (event) -> event.preventDefault() # enable drag and drop
  menu.on 'dragleave', 'li', (event) -> event.preventDefault() # enable drag and drop

  menu.on 'dragover', 'li', (event) ->
    node = $(this)

    if (node.hasClass('dropdown') || node.hasClass('dropdown-submenu')) && !node.hasClass('open') # This is a menu, expand it
      node.siblings().removeClass('open').find('open').removeClass('open')
      node.addClass('open')
    else
      event.preventDefault()

    # If I don't have the placeholder class already
    if node.hasClass('placeholder') == false
      menu.find('.placeholder').removeClass('placeholder')
      menu.find('open').removeClass('open')
      node.addClass('placeholder')

    event.stopPropagation() # fix on the child LI

  menu.on 'dragend', 'li', (event) ->
    obj = $(event.currentTarget)
    obj.css('opacity', '1.0');
    menu.find('.placeholder').removeClass('placeholder')
    menu.removeClass('dragging')

  menu.on 'drop', 'li', (event) ->
    node = $(event.currentTarget)

    node.before(event.originalEvent.dataTransfer.getData('text/html'))
    node.siblings('.open').removeClass('open')

    menu.find('.placeholder').removeClass('placeholder')
    menu.removeClass('dragging')

    draggable.remove() if draggable

    event.stopPropagation()
    event.preventDefault()

  # All Done
  menu.data('effective-menu-initialized', true)

$ -> initialize()
$(document).on 'page:change', -> initialize()
