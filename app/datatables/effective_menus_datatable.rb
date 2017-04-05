unless Gem::Version.new(EffectiveDatatables::VERSION) < Gem::Version.new('3.0')
  class EffectiveMenusDatatable < Effective::Datatable
    collection do
      Effective::Menu.all
    end

    datatable do
      col :id, visible: false
      col :updated_at, visible: false

      col :title

      actions_col partial: 'admin/menus/actions', partial_as: :menu
    end
  end
end
