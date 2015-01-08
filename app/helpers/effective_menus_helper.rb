module EffectiveMenusHelper
  def render_menu(menu, options = {})
    menu = Effective::Menu.find_by_title(menu) if menu.kind_of?(String)
    return "<ul class='nav navbar-nav'><li>Menu '#{menu}' does not exist</li></ul>".html_safe if !menu.present?

    if (effectively_editting? rescue false)
      options[:menu_id] = menu.id
      form_for(menu, :url => '/') { |form| options[:form] = form }
    end

    render_menu_items(menu.menu_items.last(menu.menu_items.size-1), options)

    # if options[:for_editor]
    #else
    #  Rails.cache.fetch(menu) { render_menu_items(menu.menu_items, options) }
    #end
  end

  def render_menu_items(items, options = {})
    if options[:form].present? && options[:form].kind_of?(ActionView::Helpers::FormBuilder) == false
      raise 'Expecting ActionView::Helpers::FormBuilder object for :form => option'
    end

    html = ""
    stack = [Effective::MenuItem.new(:lft => 1, :rgt => 9999999)] # A stack to keep track of rgt values.  Initialized with a value > max(items.rgt)

    items.each_with_index do |item, index|
      if stack.size > 0
        if (item.rgt < stack.last.rgt) # Level down?
          if index == 0
            if options[:form]
              html << "<ul class='nav navbar-nav effective-menu' data-effective-menu-id='#{options[:menu_id]}'>"
             else
              html << "<ul class='nav navbar-nav'>"
            end
          else
            html << "<ul class='dropdown-menu'>"
          end
        end

        while item.rgt > stack.last.rgt # Level up?
          stack.pop
          html << '</ul></li>' if (item.rgt > stack.last.rgt)
        end
      end

      stack.push(item)

      # This is where we actually build out an item
      classes = (item.classes || '').split(' ')
      classes << 'first' if index == 0
      classes << 'last' if (index+1) == items.length

      if item.leaf?
        html << "<li>"
        html << "<a href='#{item.url}'>#{item.title}</a>"

        if options[:form]
          html << (render(:partial => 'admin/menus/item', :locals => { :item => item, :form => options[:form] }))
        end
        html << "</li>"
      else
        html << "<li class='dropdown'>" # dropdown
        html << "<a href='#{item.url}' data-toggle='dropdown'>#{item.title}</a>"
        if options[:form]
          html << (render(:partial => 'admin/menus/item', :locals => { :item => item, :form => options[:form] }))
        end
      end

    end # /each

    while stack.size > 0
      item = stack.pop

      if item.rgt == 9999999
        html << '</ul>'
      elsif item.leaf? == false
        html << '</ul></li>'
      end
    end

    html.html_safe
  end
end
