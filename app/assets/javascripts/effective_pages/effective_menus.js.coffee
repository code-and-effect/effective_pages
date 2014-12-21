# initialize = ->
#   menu = $('.effective-menu')
#   return if menu.data('effective-menu-initialized') == true

#   menu.find('ul').sortable({
#     group: 'nav'
#     nested: true
#     vertical: false

# <<<<<<< Updated upstream
#     afterMove: (placeholder, container, closestItem) ->
#       console.log 'after move'
#       #console.log container.el
#       console.log closestItem

#       if closestItem.hasClass('dropdown') && !closestItem.hasClass('open') # This is a menu, expand it
#         menu.find('.open').removeClass('open')
#         closestItem.addClass('open')

# =======
#     afterMove: (placeholder, container, item) ->
#       if item.parent().parent().hasClass('open')
#         console.log 'open'
#       else
#         detached = placeholder.detach()
#         item.parent().parent().siblings('.open').find('ul').append(detached)
#         console.log 'closed'


#   # onDragStart: function (item, container, _super) {
#   #   // Duplicate items of the no drop area
#   #   if(!container.options.drop)
#   #     item.clone().insertAfter(item)
#   #   _super(item)
#   # }
#     # onDragStart: (item, container, _super) ->
#     #   console.log 'on drag start'
#     #   console.log item
#     #   console.log container
#     #   console.log container.rootGroup
#     #   console.log container.options
#     #   _super(item)

#     #   item.find('.dropdown-menu').sortable('disable')
#     #   _super(item, container)



#     # afterMove: (placeholder, container) ->
# >>>>>>> Stashed changes
#     #   if oldContainer != container
#     #     if oldContainer
#     #       oldContainer.el.removeClass('active')
#     #     container.el.addClass('active')
#     #   oldContainer = container

#     # onDragStart: (item, container, _super) ->
#     #   item.find('.dropdown-menu').sortable('disable')
#     #   _super(item, container)
#     onDrop: (item, container, _super) ->
#       console.log 'on drop'
#       item.find('.dropdown-menu').sortable('enable')
#       _super(item, container)
#   })

#   # menu.find('.dropdown-menu').sortable({
#   #   group: 'nav'
#   #   nested: false
#   # })

#   menu.find("a[data-toggle='dropdown']").hover(
#     ->
#       $(this).closest('.effective-menu').find('li.dropdown.open').removeClass('open')
#       $(this).closest('li.dropdown').addClass('open')
#   )

#   # All Done
#   menu.data('effective-menu-initialized', true)

# $ -> initialize()
# $(document).on 'page:change', -> initialize()
