class EffectivePagesDatatable < Effective::Datatable

  datatable do
    order :title, :asc
    length :all

    col :id, visible: false
    col :updated_at, visible: false

    col :title
    col :slug
    col :draft

    actions_col partial: 'admin/pages/actions', partial_as: :page
  end

  collection do
    Effective::Page.all
  end

end
