module EffectiveMenusHelper
  def render_menu(menu, options = {})
    menu = Effective::Menu.find_by_title(menu) if menu.kind_of?(String)
    return "<ul class='nav navbar-nav'><li>Menu '#{menu}' does not exist</li></ul>".html_safe if !menu.present?

    if (effectively_editting? rescue false)
      options[:menu_id] = menu.id
      form_for(menu, :url => '/') { |form| options[:form] = form }
    end

    render_menu_items(menu.menu_items, options)

    # if options[:for_editor]
    #else
    #  Rails.cache.fetch(menu) { render_menu_items(menu.menu_items, options) }
    #end
  end

  def render_menu_items(items, options = {})
    if options[:form].present? && options[:form].kind_of?(ActionView::Helpers::FormBuilder) == false
      raise 'Expecting ActionView::Helpers::FormBuilder object for :form => option'
    end

    html = ''

    if options[:form]
      html << "<ul class='nav navbar-nav effective-menu #{options[:class]}'"
        html << " data-effective-menu-id='#{options[:menu_id] || 0}'"
        html << " data-effective-menu-expand-html=\"#{render(:partial => 'admin/menu_items/expand').gsub('"', "'").gsub("\n", '').gsub('  ', '')}\""
        html << " data-effective-menu-new-html=\"#{render(:partial => 'admin/menu_items/new', :locals => { :item => Effective::MenuItem.new(), :form => options[:form] }).gsub('"', "'").gsub("\n", '').gsub('  ', '').gsub('[0]', '[:new]').gsub('_0_', '_:new_')}\""
      html << ">"
    else
      html << "<ul class='nav navbar-nav#{' ' + options[:class].to_s if options[:class].present?}'>"
    end

    stack = [items.to_a.first] # A stack to keep track of rgt values.

    items.each_with_index do |item, index|
      next if index == 0

      if stack.size > 1
        html << "<ul class='dropdown-menu'>" if (item.rgt < stack.last.rgt) # Level down?

        while item.rgt > stack.last.rgt # Level up?
          stack.pop
          html << "</ul></li>" if (item.rgt > stack.last.rgt)
        end
      end

      # Render the <li>...</li>
      html << render_menu_item(item, stack.size == 1, options)

      stack.push(item)
    end

    while stack.size > 0
      item = stack.pop

      if stack.size == 0 # Very last one
        html << render(:partial => 'admin/menu_items/actions') if options[:form]
        html << '</ul>'
      elsif item.leaf? == false
        html << '</ul></li>'
      end
    end

    html.html_safe
  end

  private

  # This is where we actually build out an li item
  def render_menu_item(item, caret, options)
    html = ""

    url = (
      if item.menuable.present?
        effective_pages.page_path(item.menuable)
      elsif item.divider?
        nil
      elsif (item.special || '').end_with?('_path')
        self.send(item.special) rescue nil
      elsif item.url.present?
        item.url
      end
    ).presence || '#'

    classes = (item.classes || '').split(' ')
    classes << 'active' if request.try(:fullpath) == url
    classes << 'divider' if item.divider?
    classes << 'dropdown' if item.dropdown?
    classes = classes.join(' ')

    if item.leaf?
      html << (classes.present? ? "<li class='#{classes}'>" : "<li>")

      if !item.divider? || options[:form] # Show the URL in edit mode, but not production
        html << "<a href='#{url}'>#{item.title}</a>"
      end

      if options[:form]
        html << render(:partial => 'admin/menu_items/item', :locals => { :item => item, :form => options[:form] })
      end

      html << "</li>"
    else
      html << (classes.present? ? "<li class='#{classes}'>" : "<li>")

      html << "<a href='#{url}' data-toggle='dropdown'>#{item.title}"

      if caret # Only top level dropdowns, not sub dropdowns
        html << "<span class='caret'></span>"
      end

      html << "</a>"

      if options[:form]
        html << render(:partial => 'admin/menu_items/item', :locals => { :item => item, :form => options[:form] })
      end
    end

    html
  end

end
