module Admin
  class PagesController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_pages) }

    include Effective::CrudController

    if (config = EffectivePages.layout)
      layout(config.kind_of?(Hash) ? config[:admin] : config)
    end

    submit :save, 'Save'
    submit :save, 'Save and Add New', redirect: :new
    submit :save, 'Save and View', redirect: -> { effective_pages.page_path(resource) }
    submit :save, 'Duplicate', only: :edit, redirect: -> { effective_posts.new_admin_page_path(duplicate_id: resource.id) }

    def permitted_params
      params.require(:effective_page).permit!
    end

  end
end
