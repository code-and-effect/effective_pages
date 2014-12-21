initialize = ->
  menu = $('.effective-menu')
  return if menu.data('effective-menu-initialized') == true

  menu.find('li').prop('draggable', 'true')

  # Prevent the menu from actually working
  menu.on 'click', 'a', (event) -> event.preventDefault()

  draggable = null

  menu.find('li').on
    dragstart: (event) ->
      obj = $(event.currentTarget)
      if this.tagName == 'LI'
        event.originalEvent.dataTransfer.setData('text/html', obj[0].outerHTML)
        obj.css('opacity', '0.5')
        draggable = obj
        event.stopPropagation()

    dragenter: (event) ->
      event.preventDefault() if this.tagName == 'LI' # Only enable drag and drop on LIs

    dragleave: (event) ->
      #console.log 'drag leave'
      $(this).removeClass('placeholder')
      event.preventDefault() if this.tagName == 'LI' # Only enable drag and drop on LIs
      #event.preventDefault() # Enables dropping

    dragover: (event) ->
      node = $(this)

      console.log "dragover #{node.text()}"

      if node.hasClass('dropdown') && !node.hasClass('open') # This is a menu, expand it
        menu.find('.open').removeClass('open')
        node.addClass('open')

      node.addClass('placeholder') unless node.hasClass('placeholder')

      #console.log "dragover: #{$(this).text()}"
      event.stopPropagation() # fix on the child LI
      event.preventDefault() if this.tagName == 'LI' # Only enable drag and drop on LIs

    dragend: (event) ->
      obj = $(event.currentTarget)
      obj.css('opacity', '1.0');
      false

    drop: (event) ->
      console.log 'drop'
      $(event.currentTarget).before(event.originalEvent.dataTransfer.getData('text/html'))

      menu.find('.placeholder').removeClass('placeholder')

      if draggable
        draggable.remove()

      event.stopPropagation()
      event.preventDefault() if this.tagName == 'LI' # Only enable drag and drop on LIs


  # All Done
  menu.data('effective-menu-initialized', true)

$ -> initialize()
$(document).on 'page:change', -> initialize()
