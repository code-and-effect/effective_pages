class EffectivePagesDatatable < Effective::Datatable

  filters do
    scope :all
    scope :published
    scope :draft
    scope :on_menu
  end

  datatable do
    order :title, :asc
    length :all

    col :id, visible: false
    col :updated_at, visible: false

    col :title
    col :menu_title
    col :menu_name

    col :slug do |page|
      link_to(page.slug, effective_pages.page_path(page), target: '_blank')
    end

    col :draft

    col :layout, visible: false
    col :tempate, visible: false

    col :menu_url, visible: false
    col :menu_parent, search: { collection: admin_menu_parent_collection(), grouped: true }
    col :menu_position, visible: false

    col :authenticate_user, visible: false
    col :roles, visible: false

    actions_col do |page|
      dropdown_link_to('View', effective_pages.page_path(page), target: '_blank')
    end
  end

  collection do
    Effective::Page.deep.all
  end

end
