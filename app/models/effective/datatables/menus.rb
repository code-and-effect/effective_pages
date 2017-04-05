if Gem::Version.new(EffectiveDatatables::VERSION) < Gem::Version.new('3.0')
  module Effective
    module Datatables
      class Menus < Effective::Datatable
        datatable do
          table_column :id, visible: false
          table_column :updated_at, visible: false

          table_column :title
          actions_column partial: '/admin/menus/actions'
        end

        def collection
          Effective::Menu.all
        end
      end
    end
  end
end
