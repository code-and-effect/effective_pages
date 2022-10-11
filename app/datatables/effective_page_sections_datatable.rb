class EffectivePageSectionsDatatable < Effective::Datatable

  datatable do
    order :name, :asc
    length :all

    col :id, visible: false
    col :updated_at, visible: false

    col :name
    col :hint

    col :title
    col :rich_text_body

    col :file

    col :link_label, visible: false
    col :link_url, visible: false
    col :caption, visible: false

    actions_col
  end

  collection do
    Effective::PageSection.deep.all
  end

end
