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

  def render_page_menu(page, options = {}, &block)
    raise('expected a page with menu true') unless page.kind_of?(Effective::Page) && page.menu?

    content_tag(:ul, options) { render('effective/pages/page_menu', page: page) }
  end

  def render_breadcrumbs(menu, page = @page, root: 'Home')
    return breadcrumbs_root_url(page, root: root) if request.path == '/'
    return breadcrumbs_fallback(page, root: root) unless page.kind_of?(Effective::Page)

    parents = [page.menu_parent&.menu_parent, page.menu_parent].compact

    content_tag(:ol, class: 'breadcrumb') do
      (
        [content_tag(:li, link_to(root, root_path, title: root), class: 'breadcrumb-item')] +
        parents.map do |page|
          next if page.menu_root_with_children? # Don't show root pages becaues they have no content

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

  def admin_menu_parent_collection(page = nil)
    raise('expected a page') if page.present? && !page.kind_of?(Effective::Page)

    pages = Effective::Page.menuable.root_level.where.not(id: page)

    if EffectivePages.max_menu_depth == 2
      # You can only select root level pages
      pages.group_by(&:menu_name)
    elsif EffectivePages.max_menu_depth == 3
      # You can only select root level pages and immediate children
      pages.map do |page|
        [[page.to_s, page.id, page.menu_name]] + page.menu_children.map do |child|
          label = content_tag(:div) do
            arrow = "&rarr;"
            group = content_tag(:span, child.menu_group, class: 'badge badge-info') if child.menu_group.present?
            title = child.menu_to_s

            [arrow, group, title].compact.join(' ').html_safe
          end

          [child.to_s, child.id, { 'data-html': label }, child.menu_name]
        end
      end.flatten(1).group_by(&:last)
    end
  end

end
