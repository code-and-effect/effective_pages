class EffectiveTagsDatatable < Effective::Datatable

  datatable do
    col :id, visible: false
    col :updated_at, visible: false

    col :name

    actions_col
  end

  collection do
    Effective::Tag.deep.all
  end

end
