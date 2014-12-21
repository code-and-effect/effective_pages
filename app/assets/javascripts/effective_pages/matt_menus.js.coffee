# initialize = ->
#   menu = $('.effective-menu')
#   return if menu.data('effective-menu-initialized') == true

#   menu.find('li').prop('draggable', 'true')

#   # Prevent the menu from actually working
#   menu.on 'click', 'a', (event) -> event.preventDefault()

#   draggable = null

#   menu.find('li').on
#     dragstart: (event) ->
#       obj = $(event.currentTarget)
#       event.originalEvent.dataTransfer.setData('text/html', obj[0].outerHTML)
#       obj.css('opacity', '0.5')
#       draggable = obj
#       event.stopPropagation()

#     dragenter: (event) ->
#       #console.log 'drag enter'
#       event.preventDefault() # Enables dropping

#     dragleave: (event) ->
#       #console.log 'drag leave'
#       event.preventDefault() # Enables dropping

#     dragover: (event) ->
#       node = $(this)

#       console.log "dragover #{node.text()}"

#       if node.hasClass('dropdown') && !node.hasClass('open') # This is a menu, expand it
#         menu.find('.open').removeClass('open')
#         node.addClass('open')

#       #console.log "dragover: #{$(this).text()}"
#       event.stopPropagation() # fix on the child LI
#       event.preventDefault() # Enables dropping

#     dragend: (event) ->
#       obj = $(event.currentTarget)
#       obj.css('opacity', '1.0');
#       false

#     drop: (event) ->
#       console.log 'drop'
#       $(event.currentTarget).before(event.originalEvent.dataTransfer.getData('text/html'))

#       if draggable
#         draggable.remove()

#       event.stopPropagation()
#       event.preventDefault()


#   # All Done
#   menu.data('effective-menu-initialized', true)

# $ -> initialize()
# $(document).on 'page:change', -> initialize()
