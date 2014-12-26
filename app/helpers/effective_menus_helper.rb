module EffectiveMenusHelper
  def render_menu(menu, options = {})
    menu = Effective::Menu.find_by_title(menu) if menu.kind_of?(String)

    return "<ul class='nav navbar-nav'><li>Menu '#{menu}' does not exist</li></ul>".html_safe if !menu.present?

    render_menu_items(menu.menu_items.last(menu.menu_items.size-1), options)
    # if options[:for_editor]
    #else
    #  Rails.cache.fetch(menu) { render_menu_items(menu.menu_items, options) }
    #end
  end


  def render_menu_items(items, options = {})
    return "<ul></ul>".html_safe if !items.present?

    html = ""
    stack = Array.new(1, 999999) # A stack to keep track of menu_node.r values.  Initialized with a number > max(menu_items.r) values

    items.each_with_index do |item, index|
      if stack.size > 0
        if (item.rgt < stack.last) # Level down?
          if index == 0
            html << "<ul class='nav navbar-nav'>"
          else
            html << "<ul class='dropdown-menu'>"
          end
        end

        while item.rgt > stack.last # Level up?
          stack.pop
          html << "</ul></li>" if (item.rgt > stack.last)
        end
      end

      stack.push(item.rgt)

      if false #options[:for_editor]
        html << (render(:partial => 'admin/menu_items/menu_item', :locals => { :menu_item => item })).gsub(/\n/,'').gsub(/  /, '')
      else
        # This is where we actually build out an item
        classes = (item.classes || '').split(' ')
        classes << 'first' if index == 0
        classes << 'last' if (index+1) == items.length

        if (item.lft + 1) == item.rgt # leaf node
          html << "<li>"
          html << "<a href='#{item.url}'>#{item.title}</a>"
        else
          html << "<li class='dropdown'>" # dropdown
          html << "<a href='#{item.url}' data-toggle='dropdown'>#{item.title}</a>"
        end
      end

      html << '</li>' if (item.lft + 1) == stack.last
    end

    stack.each do |item|
      stack.pop
      html << '</ul>'
      html << '</li>' if stack.size > 1
    end

    html.html_safe
   end
end
