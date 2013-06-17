@Mercury.config.toolbars.primary.insert_effective_asset = ['Asset', 'Insert Asset', { modal: '/admin/effective_assets', regions: ['full', 'markdown'] }]

@Mercury.modalHandlers.insert_effective_asset = ->
  @element.addClass('effective-asset-modal')

  @element.find('.asset-insertable').on 'click', (event) =>
    to_insert = $(event.currentTarget).data('asset')
    Mercury.trigger('action', {action: 'insertHTML', value: to_insert})
    @hide()
