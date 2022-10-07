class EffectivePagesMenuDatatable < Effective::Datatable

  datatable do
    reorder :menu_position

    if attributes[:menu_parent_id].present?
      col :menu_parent
    end

    col :title do |page|
      link_to(page, effective_pages.edit_admin_page_path(page))
    end

    col :menu_url, label: 'Redirect Url'
    col :menu_position, label: 'Position', visible: false

    # We only support depth 2 and 3.
    col :menu_children, label: 'Children' do |page|
      page.menu_children.group_by(&:menu_group).values.flatten.map do |child|
        content_tag(:div, class: 'col-resource_item') do
          link = link_to(child.admin_menu_label, effective_pages.edit_admin_page_path(child))

          list = child.menu_children.group_by(&:menu_group).values.flatten.map do |child|
            content_tag(:li, link_to(child.admin_menu_label, effective_pages.edit_admin_page_path(child)))
          end

          link + (content_tag(:ul, list.join.html_safe) if list.present?).to_s
        end
      end.join.html_safe
    end

    actions_col(new: false, destroy: false)
  end

  collection(apply_belongs_to: false) do
    scope = Effective::Page.deep.menuable

    if attributes[:menu].present?
      scope = scope.root_level.for_menu(menu)
    end

    if attributes[:page_id].present?
      scope = scope.where(menu_parent_id: attributes[:page_id])
    end

    scope
  end

  def menu
    menu = EffectivePages.menus.find { |menu| menu.to_s == attributes[:menu].to_s }
    menu || raise("unexpected menu: #{attributes[:menu] || 'none'}")
  end

end
