class EffectivePermalinksDatatable < Effective::Datatable

  datatable do
    col :id, visible: false
    col :updated_at, visible: false

    col :title
    col :slug
    col :summary

    actions_col
  end

  collection do
    Effective::Permalink.deep.all
  end

end
