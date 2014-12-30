(($, window) ->
  class EffectiveMenuEditor
    defaults:
      menuClass: 'effective-menu'

    menu: null
    draggable: null

    constructor: (el, options) ->
      @options = $.extend({}, @defaults, options)
      @menu = $(el)

      @initDragDropEvents()
      @initFormEvents()
      @initAdditionalEvents()
      true

    initDragDropEvents: ->
      @menu.on 'dragenter', 'li', (event) => event.preventDefault() if @draggable  # enable drag and drop
      @menu.on 'dragleave', 'li', (event) => event.preventDefault() if @draggable # enable drag and drop

      @menu.on 'dragstart', 'li', (event) =>
        @draggable = node = $(event.currentTarget)
        event.originalEvent.dataTransfer.setData('text/html', node[0].outerHTML)

        node.css('opacity', '0.4') # Show it slightly removed from the DOM
        @menu.addClass('dragging')
        event.stopPropagation()

      @menu.on 'dragover', 'li', (event) =>
        return false unless @draggable

        node = $(event.currentTarget)

        if (node.hasClass('dropdown') || node.hasClass('dropdown-submenu')) && !node.hasClass('open') # This is a menu, expand it
          @menu.find('.open').removeClass('open')
          node.parentsUntil(@menu, 'li').andSelf().addClass('open')
        else
          event.preventDefault()

        # If I don't have the placeholder class already
        if node.hasClass('placeholder') == false
          @menu.find('.placeholder').removeClass('placeholder')
          node.addClass('placeholder')

        event.stopPropagation()

      @menu.on 'dragend', 'li', (event) =>
        return false unless @draggable

        node = $(event.currentTarget)
        node.css('opacity', '1.0')
        @menu.removeClass('dragging').find('.placeholder').removeClass('placeholder')
        @draggable = null

      @menu.on 'drop', 'li', (event) =>
        return false unless @draggable

        node = $(event.currentTarget)

        node.before(event.originalEvent.dataTransfer.getData('text/html'))

        @menu.removeClass('dragging').find('.placeholder').removeClass('placeholder')

        @draggable.remove() if @draggable
        @draggable = null

        event.stopPropagation()
        event.preventDefault()

    initFormEvents: ->
      @menu.closest('form').on 'submit', (event) => @assignLftRgt()

    initAdditionalEvents: ->
      @menu.on 'click', 'a', (event) -> event.preventDefault()

    assignLftRgt: ->
      stack = []
      console.log @menu.find('li')

      @menu.find('li').each (item) ->
        console.log 'item'


  $.fn.extend effectiveMenuEditor: (option, args...) ->
    @each ->
      $this = $(this)
      data = $this.data('effectiveMenuEditor')

      $this.data('effectiveMenuEditor', (data = new EffectiveMenuEditor(this, option))) if !data
      data[option].apply(data, args) if typeof option == 'string'
      $this

) window.jQuery, window
