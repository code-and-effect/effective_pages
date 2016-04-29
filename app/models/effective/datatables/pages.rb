if defined?(EffectiveDatatables)
  module Effective
    module Datatables
      class Pages < Effective::Datatable
        datatable do
          default_order :title, :asc
          default_entries :all

          table_column :id, visible: false

          table_column :title
          table_column :slug
          table_column :draft

          actions_column partial: '/admin/pages/actions'
        end

        def collection
          Effective::Page.all
        end
      end
    end
  end
end
