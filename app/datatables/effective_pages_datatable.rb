unless Gem::Version.new(EffectiveDatatables::VERSION) < Gem::Version.new('3.0')
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
end
