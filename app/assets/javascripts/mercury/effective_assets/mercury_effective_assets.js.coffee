@Mercury.config.toolbars.primary.insert_effective_asset = ['Asset', 'Insert Asset', { modal: 'effective_assets.html', regions: ['full', 'markdown'] }]

@Mercury.preloadedViews['effective_assets.html'] = ("<div class='mercury-display-pane-container form-inputs'>" + "<iframe id='effective_assets_iframe' src='/admin/effective_assets' width='100%' height='100%' marginWidth='0' marginHeight='0' frameBorder='0' scrolling='auto'></iframe>" + "</div>" + "<div class='form-actions mercury-display-controls'>" + "<input class='btn btn-primary' type='submit' value='Close'>" + "</div>")

@Mercury.modalHandlers.insert_effective_asset = ->
  #@element.addClass('effective-asset-modal')
  modal_dialog = this

  @element.on 'click', (event) ->
    event.preventDefault()
    modal_dialog.hide()

  $('#effective_assets_iframe').on 'load', ->
    $(this).contents().find('a.asset-insertable').on 'click', (event) ->
      event.preventDefault()
      to_insert = $(event.currentTarget).data('asset')
      Mercury.trigger('action', {action: 'insertHTML', value: to_insert})
