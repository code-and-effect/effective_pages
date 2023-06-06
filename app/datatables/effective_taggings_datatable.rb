class EffectiveTaggingsDatatable < Effective::Datatable

  datatable do
    col :id, visible: false

    col :tag_name, label: 'Tag'
    col :tagged_on

    col :created_at
  end

  collection do
    Effective::Tagging.deep.all
  end

end
