module Effective
  class PagesController < ApplicationController
    def show
      @pages = Effective::Page.all
      @pages = @pages.published unless EffectivePages.authorized?(self, :admin, :effective_pages)

      @page = @pages.find(params[:id])

      raise ActiveRecord::RecordNotFound unless @page.present? # Incase .find() isn't raising it
      raise Effective::AccessDenied.new('Access Denied', :show, @page) unless @page.roles_permit?(current_user)

      EffectivePages.authorized?(self, :show, @page)

      @page_title = @page.title
      @meta_description = @page.meta_description
      @canonical_url = effective_pages.page_url(@page)

      if EffectivePages.authorized?(self, :admin, :effective_pages)
        flash.now[:warning] = [
          'Hi Admin!',
          ('You are viewing a hidden page.' unless @page.published?),
          'Click here to',
          ("<a href='#{effective_regions.edit_path(effective_pages.page_path(@page))}' class='alert-link'>edit page content</a> or" unless admin_edit?),
          ("<a href='#{effective_pages.edit_admin_page_path(@page)}' class='alert-link'>edit page settings</a>.")
        ].compact.join(' ')
      end

      render @page.template, layout: @page.layout, locals: { page: @page }
    end

    private

    def admin_edit?
      EffectivePages.authorized?(self, :admin, :effective_posts) && (params[:edit].to_s == 'true')
    end

  end
end
