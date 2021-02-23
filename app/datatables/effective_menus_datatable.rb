class EffectiveMenusDatatable < Effective::Datatable

  datatable do
    col :id, visible: false
    col :updated_at, visible: false

    col :title

    actions_col
  end

  collection do
    Effective::Menu.all
  end

end
