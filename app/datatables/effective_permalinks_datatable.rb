class EffectivePermalinksDatatable < Effective::Datatable

  datatable do
    col :id, visible: false
    col :updated_at, visible: false

    col :title

    col(:url) do |permalink|
      url = (root_url + "link/" + permalink.slug)
      link_to(url, url, target: '_blank')
    end

    col :summary

    col :slug, visible: false
    col :tags, visible: false

    col :tracks_count, label: 'Views'

    actions_col
  end

  collection do
    Effective::Permalink.deep.all
  end

end
