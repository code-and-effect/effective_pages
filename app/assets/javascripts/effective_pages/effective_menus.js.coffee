initialize = ->
  menu = $('.effective-menu')
  return if menu.data('effective-menu-initialized') == true

  menu.find('ul.nav').sortable({
    group: 'nav'
    nested: false
    vertical: false

    # afterMove: (placeholder, container) ->
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
