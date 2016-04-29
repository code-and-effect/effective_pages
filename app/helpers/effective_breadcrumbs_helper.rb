module EffectiveBreadcrumbsHelper
  def render_breadcrumbs(menu, page)
    menu = Effective::Menu.find_by_title(menu) if menu.kind_of?(String)
    return "Menu '#{menu}' does not exist".html_safe unless menu.present?

    return breadcrumbs_fallback(page) if !page.present?

    menu_item = if page.kind_of?(Effective::Page)
      url = effective_pages.page_path(page)
      menu.menu_items.find { |item| item.menuable == page || item.title == page.title || item.url == url }
    else
      menu.menu_items.find { |item| item.menuable == page || item.title == page || item.url == page }
    end

    return breadcrumbs_fallback(page) unless menu_item.present?

    parents = menu.menu_items.select { |item| item.lft < menu_item.lft && item.rgt > menu_item.rgt }

    content_tag(:ol, class: 'breadcrumb') do
      (
        parents.map { |parent| content_tag(:li, link_to(parent.title, parent.url.presence || '#', title: parent.title)) } +
        [content_tag(:li, page.try(:title) || page, class: 'active')]
      ).join().html_safe
    end
  end

  alias_method :render_breadcrumb, :render_breadcrumbs

  def breadcrumbs_fallback(page)
    content_tag(:ol, class: 'breadcrumb') do
      [
        content_tag(:li, link_to('Home', '/', title: 'Home')),
        content_tag(:li, (page.try(:title) || page || @page_title || 'Here'), class: 'active')
      ].join().html_safe
    end
  end

end
