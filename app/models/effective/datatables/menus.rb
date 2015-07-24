if defined?(EffectiveDatatables)
  module Effective
    module Datatables
      class Menus < Effective::Datatable
        datatable do
          table_column :id

          table_column :title
          table_column :actions, :sortable => false, :filter => false, :partial => '/admin/menus/actions'
        end

        def collection
          Effective::Menu.all
        end
      end
    end
  end
end
