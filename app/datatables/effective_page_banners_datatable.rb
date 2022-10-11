class EffectivePageBannersDatatable < Effective::Datatable

  datatable do
    order :name, :asc
    length :all

    col :id, visible: false
    col :updated_at, visible: false

    col :name

    col :file
    col :caption

    col :rich_text_body, visible: false
    col :pages

    actions_col
  end

  collection do
    Effective::PageBanner.deep.all
  end

end
