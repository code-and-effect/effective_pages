class EffectiveAlertsDatatable < Effective::Datatable

  datatable do
    col :id, visible: false
    col :updated_at, visible: false

    col :enabled

    col :rich_text_body, label: 'Content'

    actions_col
  end

  collection do
    Effective::Alert.deep.all
  end

end
