initialize = ->
  menu = $('.effective-menu')
  return if menu.data('effective-menu-initialized') == true

  menu.find('ul.nav').sortable({
    group: 'nav'
    nested: true
    vertical: false

    afterMove: (placeholder, container, closestItem) ->
      console.log 'after move'
      #console.log container.el
      console.log closestItem

      if closestItem.hasClass('dropdown') && !closestItem.hasClass('open') # This is a menu, expand it
        menu.find('.open').removeClass('open')
        closestItem.addClass('open')

    #   if oldContainer != container
    #     if oldContainer
    #       oldContainer.el.removeClass('active')
    #     container.el.addClass('active')
    #   oldContainer = container

    onDragStart: (item, container, _super) ->
      item.find('.dropdown-menu').sortable('disable')
      _super(item, container)
    onDrop: (item, container, _super) ->
      item.find('.dropdown-menu').sortable('enable')
      _super(item, container)
  })

  menu.find('.dropdown-menu').sortable({
    group: 'nav'
  })

  # menu.find("a[data-toggle='dropdown']").hover(
  #   ->
  #     $(this).closest('.effective-menu').find('li.dropdown.open').removeClass('open')
  #     $(this).closest('li.dropdown').addClass('open')
  # )

  # All Done
  menu.data('effective-menu-initialized', true)

$ -> initialize()
$(document).on 'page:change', -> initialize()
