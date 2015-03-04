module EffectiveMenusAdminHelper

  def visible_badge(menu_item, stack, comparator, is_role = false)
    binding.pry if is_role

    visible = comparator.call(menu_item) && stack.all? { |parent_menu_item| parent_menu_item.lft == 1 || comparator.call(parent_menu_item) }
    content_tag(:span, (visible ? 'YES'.freeze : 'NO'.freeze), :class => "label label-#{(visible ? 'primary' : 'warning')}")
  end

end
