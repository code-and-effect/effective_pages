# frozen_string_literal: true
module EffectiveMenusHelper

  def render_menu(name, options = {}, &block)
    name = name.to_s
    menu = Array(EffectivePages.menus).find { |menu| menu.to_s == name }

    if menu.blank?
      raise("unable to find menu #{name}. Please add it to config/initializers/effective_pages.rb")
    end

    content_tag(:ul, options) { render('effective/pages/menu', menu: menu) }
  end

  def render_breadcrumbs(menu, page = @page, root: 'Home')
    return breadcrumbs_root_url(page, root: root) if request.path == '/'
    return breadcrumbs_fallback(page, root: root) unless page.kind_of?(Effective::Page)

    parents = [page.menu_parent].compact

    content_tag(:ol, class: 'breadcrumb') do
      (
        [content_tag(:li, link_to(root, root_path, title: root), class: 'breadcrumb-item')] +
        parents.map do |page|
          url = (page.menu_url.presence || effective_pages.page_path(page))
          content_tag(:li, link_to(page, url, title: page.title), class: 'breadcrumb-item')
        end +
        [content_tag(:li, page, class: 'breadcrumb-item active', 'aria-current': 'page')]
      ).join.html_safe
    end
  end

  alias_method :render_breadcrumb, :render_breadcrumbs

  def breadcrumbs_root_url(page = @page, root: 'Home')
    content_tag(:ol, class: 'breadcrumb') do
      content_tag(:li, root, class: 'breadcrumb-item active', 'aria-current': 'page')
    end
  end

  def breadcrumbs_fallback(page = @page, root: 'Home')
    label = (page if page.kind_of?(Effective::Page)) || @page_title || 'Here'

    content_tag(:ol, class: 'breadcrumb') do
      [
        content_tag(:li, link_to(root, root_path, title: root), class: 'breadcrumb-item'),
        content_tag(:li, label, class: 'breadcrumb-item active', 'aria-current': 'page')
      ].join.html_safe
    end
  end

end
