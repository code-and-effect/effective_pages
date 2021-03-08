class EffectivePagesMenuDatatable < Effective::Datatable

  datatable do
    reorder :menu_position

    if attributes[:menu_parent_id].present?
      col :menu_parent
    end

    col :title
    col :menu_url, label: 'Path or URL'

    col :menu_position, visible: false

    actions_col(new: false)
  end

  collection(apply_belongs_to: false) do
    scope = Effective::Page.for_menu(menu)

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
