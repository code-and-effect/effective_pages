# frozen_string_literal: true

module EffectivePageSegmentsHelper

  # This is a scrollspy navbar
  # = render_page_segments_menu(class: 'navbar navbar-light bg-light')
  def render_page_segments_menu(page = nil, options = {})
    (options = page; page = nil) if page.kind_of?(Hash)
    page ||= @page

    raise('Expected an Effective::Page') if page && !page.kind_of?(Effective::Page)
    raise('Expected a Hash of options') unless options.kind_of?(Hash)

    return if page.blank?
    return if page.page_segments.blank?
    return unless page.template_page_segments?

    # Default options
    options[:class] ||= 'navbar navbar-light bg-light'

    render('effective/page_segments/menu', page: page, html_options: options)
  end

  # Renders all page segments for one page
  def render_page_segments(page = nil, options = {})
    (options = page; page = nil) if page.kind_of?(Hash)
    page ||= @page

    raise('Expected an Effective::Page') if page && !page.kind_of?(Effective::Page)
    raise('Expected a Hash of options') unless options.kind_of?(Hash)

    return if page.blank?
    return if page.page_segments.blank?

    render('effective/page_segments/content', page: page, html_options: options)
  end

end
