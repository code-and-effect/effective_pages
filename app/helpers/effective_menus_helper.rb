module EffectiveMenusHelper
  def render_menu(menu, options = {}, &block)
    menu = Effective::Menu.find_by_title(menu.to_s) if menu.kind_of?(String) || menu.kind_of?(Symbol)
    return "<ul class='nav navbar-nav'><li>Menu '#{menu}' does not exist</li></ul>".html_safe if !menu.present?

    if effectively_editting? && EffectiveResources.authorized?(controller, :edit, menu)
      options[:menu_id] = menu.id
      form_for(menu, :url => '/') { |form| options[:form] = form }
    end

    menu_items = menu.menu_items

    if menu.new_record?
      menu_items = menu_items.to_a.sort! { |a, b| a.lft <=> b.lft }
    end

    if block_given? && options[:form].blank?
      render_menu_items(menu_items, options) { yield }
    else
      render_menu_items(menu_items, options)
    end

    # if options[:for_editor]
    #else
    #  Rails.cache.fetch(menu) { render_menu_items(menu.menu_items, options) }
    #end
  end

  def render_menu_items(items, options = {}, &block)
    if options[:form].present? && options[:form].kind_of?(ActionView::Helpers::FormBuilder) == false
      raise 'Expecting ActionView::Helpers::FormBuilder object for :form => option'
    end

    html = ''

    if options[:form]
      html << "<ul class='nav navbar-nav effective-menu #{options[:class]}'"
        html << " data-effective-menu-id='#{options[:menu_id] || 0}'"
        html << " data-effective-menu-expand-html=\"#{render(:partial => 'admin/menu_items/expand').gsub('"', "'").gsub("\n", '').gsub('  ', '')}\""
        html << " data-effective-menu-new-html=\"#{render(:partial => 'admin/menu_items/new', :locals => { :item => Effective::MenuItem.new(), :form => options[:form] }).gsub('"', "'").gsub("\n", '').gsub('  ', '').gsub('[0]', '[:new]').gsub('_0_', '_:new_')}\""

        maxdepth = ((options[:maxdepth].presence || EffectivePages.menu[:maxdepth].presence).to_i rescue 0)
        html << " data-effective-menu-maxdepth='#{maxdepth}'" if maxdepth > 0

      html << ">"
    else
      html << "<ul class='nav navbar-nav#{' ' + options[:class].to_s if options[:class].present?}'>"
    end

    stack = [items.to_a.first] # A stack to keep track of rgt values.
    skip_to_lft = 0 # This lets us skip over nodes we don't have visible_for? permission to see

    items.each_with_index do |item, index|
      next if index == 0 # We always skip the first Root node

      # This allows us to skip over nodes we don't have permission to view
      next if item.lft < skip_to_lft
      if options[:form].blank? && !item.visible_for?(defined?(current_user) ? current_user : nil)
        skip_to_lft = item.rgt + 1
        next
      end

      if stack.size > 1
        html << "<ul class='dropdown-menu'>" if (item.rgt < stack.last.rgt) # Level down?

        while item.rgt > stack.last.rgt # Level up?
          stack.pop
          html << "</ul></li>" if (item.rgt > stack.last.rgt)
        end
      end

      # Render the <li>...</li> with carets only on top level dropdowns, not sub dropdowns
      html << render_menu_item(item, stack.size == 1, options)

      stack.push(item)
    end

    while stack.size > 0
      item = stack.pop

      if stack.size == 0 # Very last one
        html << render(:partial => 'admin/menu_items/actions') if options[:form]
        html << (capture(&block) || '') if block_given? && !options[:form]
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
      if item.menuable.kind_of?(Effective::Page)
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
    classes << 'active' if EffectivePages.menu[:apply_active_class] && request.try(:fullpath) == url
    classes << 'divider' if item.divider?
    classes << 'dropdown' if item.dropdown?
    classes = classes.join(' ')

    if item.leaf?
      html << (classes.present? ? "<li class='#{classes}'>" : "<li>")

      if !item.divider? || options[:form] # Show the URL in edit mode, but not normally
        html << render_menu_item_anchor_tag(item, caret, url)
      end

      if options[:form]
        html << render(:partial => 'admin/menu_items/item', :locals => { :item => item, :form => options[:form] })
      end

      html << "</li>"
    else
      html << (classes.present? ? "<li class='#{classes}'>" : "<li>")
      html << render_menu_item_anchor_tag(item, caret, url)

      if options[:form]
        html << render(:partial => 'admin/menu_items/item', :locals => { :item => item, :form => options[:form] })
      end
    end

    html
  end

  def render_menu_item_anchor_tag(item, caret, url)
    new_window_html = (item.new_window? ? " target='_blank'" : "")

    if item.special == 'destroy_user_session_path'
      "<a href='#{url}' data-method='delete' data-no-turbolink='true'>#{item.title}</a>"
    elsif item.dropdown?
      ''.tap do |html|
        html << "<a href='#{url}' data-toggle='dropdown'#{new_window_html}>#{item.title}"
        html << "<span class='caret'></span>" if caret
        html << "</a>"
      end
    else
      "<a href='#{url}'#{new_window_html}>#{item.title}</a>"
    end
  end

end
