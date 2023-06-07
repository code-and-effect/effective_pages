class Admin::EffectiveTaggingsDatatable < Effective::Datatable

  datatable do
    col :id, visible: false

    col :tag
    col :taggable

    col :created_at

    actions_col
  end

  collection do
    Effective::Tagging.deep.all
  end

end
