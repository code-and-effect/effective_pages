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
    col :menu_children, label: 'Children'

    actions_col(new: false, destroy: false)
  end

  collection(apply_belongs_to: false) do
    scope = Effective::Page.deep.for_menu(menu)

    scope = if attributes[:menu_parent_id].present?
      scope.where(menu_parent_id: attributes[:menu_parent_id])
    else
      scope.where(menu_parent_id: nil)
    end

    scope
  end

  def menu
    menu = EffectivePages.menus.find { |menu| menu.to_s == attributes[:menu].to_s }
    menu || raise("unexpected menu: #{attributes[:menu] || 'none'}")
  end

end
