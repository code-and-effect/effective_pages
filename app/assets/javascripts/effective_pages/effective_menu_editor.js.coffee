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
          node.siblings().removeClass('open').find('open').removeClass('open')
          node.addClass('open')
        else
          event.preventDefault()

        # If I don't have the placeholder class already
        if node.hasClass('placeholder') == false
          @menu.find('.placeholder').removeClass('placeholder')
          @menu.find('open').removeClass('open')
          node.addClass('placeholder')

        event.stopPropagation()

      @menu.on 'dragend', 'li', (event) =>
        return false unless @draggable

        node = $(event.currentTarget)
        node.css('opacity', '1.0');
        @menu.find('.placeholder').removeClass('placeholder')
        @menu.removeClass('dragging')
        @draggable = null

      @menu.on 'drop', 'li', (event) =>
        return false unless @draggable

        node = $(event.currentTarget)

        node.before(event.originalEvent.dataTransfer.getData('text/html'))
        #node.siblings('.open').removeClass('open')

        @menu.find('.placeholder').removeClass('placeholder')
        @menu.removeClass('dragging')

        @draggable.remove() if @draggable
        @draggable = null

        event.stopPropagation()
        event.preventDefault()

    initAdditionalEvents: ->
      @menu.on 'click', 'a', (event) -> event.preventDefault()



  $.fn.extend effectiveMenuEditor: (option, args...) ->
    @each ->
      $this = $(this)
      data = $this.data('effectiveMenuEditor')

      $this.data('effectiveMenuEditor', (data = new EffectiveMenuEditor(this, option))) if !data
      data[option].apply(data, args) if typeof option == 'string'
      $this


) window.jQuery, window


# (($) ->
#   options =
#     menuClass: 'effective-menu'

#   $.fn.effectiveMenuEditor = (method) ->

#     if (methods[method])
#       return methods[method].apply(this, Array.prototype.slice.call(arguments,1))
#     else if (typeof method == 'object' or !method)
#       return methods.init.apply(this, arguments)
#     else
#       alert "Method #{method} does not exist on jQuery.effectiveMenuEditor"

#   methods =
#     init: (opts) ->
#       @each ->
#         this.options = $.extend options, opts

#         this.menu = $(this)
#         this.draggable = null

#         if this.menu.data('effective-menu-initialized') != true
#           this.menu.addClass(options.menuClass) unless this.menu.hasClass(options.menuClass)
#           methods.initDragDropEvents()
#           methods.initOtherEvents()
#           this.menu.data('effective-menu-initialized', true)

#     initDragDropEvents: ->
#       console.log 'Init drop events'
#       console.log this.options
#       console.log this.menu

#       menu.on 'dragenter', 'li', (event) -> event.preventDefault() # enable drag and drop
#       menu.on 'dragleave', 'li', (event) -> event.preventDefault() # enable drag and drop

#       menu.on 'dragstart', 'li', (event) ->
#         console.log @menu

#         node = $(event.currentTarget)
#         event.originalEvent.dataTransfer.setData('text/html', node[0].outerHTML)

#         node.css('opacity', '0.4') # Show it slightly removed from the DOM
#         menu.addClass('dragging')

#         draggable = node
#         event.stopPropagation()


#       menu.on 'dragover', 'li', (event) ->
#         node = $(this)

#         console.log menu

#         if (node.hasClass('dropdown') || node.hasClass('dropdown-submenu')) && !node.hasClass('open') # This is a menu, expand it
#           node.siblings().removeClass('open').find('open').removeClass('open')
#           node.addClass('open')
#         else
#           event.preventDefault()

#         # If I don't have the placeholder class already
#         if node.hasClass('placeholder') == false
#           menu.find('.placeholder').removeClass('placeholder')
#           menu.find('open').removeClass('open')
#           node.addClass('placeholder')

#         event.stopPropagation() # fix on the child LI

#       menu.on 'dragend', 'li', (event) ->
#         node = $(event.currentTarget)
#         node.css('opacity', '1.0');
#         menu.find('.placeholder').removeClass('placeholder')
#         menu.removeClass('dragging')

#       menu.on 'drop', 'li', (event) ->
#         node = $(event.currentTarget)

#         node.before(event.originalEvent.dataTransfer.getData('text/html'))
#         #node.siblings('.open').removeClass('open')

#         menu.find('.placeholder').removeClass('placeholder')
#         menu.removeClass('dragging')

#         draggable.remove() if draggable

#         event.stopPropagation()
#         event.preventDefault()

#     initOtherEvents: ->
#       menu.on 'click', 'a', (event) -> event.preventDefault()

# )(jQuery)
