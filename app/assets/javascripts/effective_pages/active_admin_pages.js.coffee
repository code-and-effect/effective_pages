$(document).on 'change', 'input[name="effective_page[template]"]', (event) ->
  $('#page_templates').find('li.active').removeClass('active')

  obj = $(event.currentTarget).closest('li.template')
  obj.addClass('active')
  $('#page_templates').find("li.template-info[data-template='#{obj.data('template')}']").addClass('active')

