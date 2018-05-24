class EffectivePagesDatatable < Effective::Datatable

  datatable do
    order :title, :asc
    length :all

    col :id, visible: false
    col :updated_at, visible: false

    col :title

    col :slug do |page|
      link_to(page.slug, effective_pages.page_path(page), target: '_blank')
    end

    col :draft

    col :layout, visible: false
    col :tempate, visible: false

    actions_col partial: 'admin/pages/actions', partial_as: :page
  end

  collection do
    Effective::Page.all
  end

end
