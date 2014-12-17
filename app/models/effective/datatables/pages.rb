if defined?(EffectiveDatatables)
  module Effective
    module Datatables
      class Pages < Effective::Datatable
        table_column :id

        table_column :title
        table_column :slug
        table_column :draft

        table_column :actions, :sortable => false, :filter => false, :partial => '/admin/pages/actions'

        def collection
          Effective::Page.all
        end
      end
    end
  end
end
