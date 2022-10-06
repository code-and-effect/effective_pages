module Effective
  class PagesController < ApplicationController
    include Effective::CrudController

    def show
      @pages = Effective::Page.all
      @pages = @pages.published unless EffectiveResources.authorized?(self, :admin, :effective_pages)

      @page = @pages.find(params[:id])

      raise ActionController::RoutingError.new('Not Found') if @page.menu_root_with_children?

      if @page.authenticate_user? || @page.roles.present?
        authenticate_user!
      end

      raise Effective::AccessDenied.new('Access Denied', :show, @page) unless @page.roles_permit?(current_user)
      EffectiveResources.authorize!(self, :show, @page)

      @page_title = @page.title
      @meta_description = @page.meta_description
      @canonical_url = effective_pages.page_url(@page)

      if EffectiveResources.authorized?(self, :admin, :effective_pages)
        flash.now[:warning] = [
          'Hi Admin!',
          ('You are viewing a draft page.' unless @page.published?),
          ("<a href='#{effective_pages.edit_admin_page_path(@page)}' class='alert-link'>Click here to edit this page</a>.")
        ].compact.join(' ')
      end

      template = File.join(EffectivePages.pages_path, @page.template)
      layout = File.join(EffectivePages.layouts_path, @page.layout)

      render(template, layout: layout, locals: { page: @page })
    end

    private

    def admin_edit?
      EffectiveResources.authorized?(self, :admin, :effective_pages) && (params[:edit].to_s == 'true')
    end

  end
end
