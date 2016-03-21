module Admin
  class PagesController < ApplicationController
    before_filter :authenticate_user!   # This is devise, ensure we're logged in.

    layout (EffectivePages.layout.kind_of?(Hash) ? EffectivePages.layout[:admin] : EffectivePages.layout)

    def index
      @page_title = 'Pages'
      EffectivePages.authorized?(self, :index, Effective::Page)

      @datatable = Effective::Datatables::Pages.new() if defined?(EffectiveDatatables)
    end

    def new
      @page = Effective::Page.new()
      @page_title = 'New Page'

      EffectivePages.authorized?(self, :new, @page)
    end

    def create
      @page = Effective::Page.new(page_params)
      @page_title = 'New Page'

      EffectivePages.authorized?(self, :create, @page)

      if @page.save
        if params[:commit] == 'Save and Edit Content' && defined?(EffectiveRegions)
          redirect_to effective_regions.edit_path(effective_pages.page_path(@page), :exit => effective_pages.edit_admin_page_path(@page))
        elsif params[:commit] == 'Save and Add New'
          redirect_to effective_pages.new_admin_page_path
        else
          flash[:success] = 'Successfully created page'
          redirect_to effective_pages.edit_admin_page_path(@page)
        end
      else
        flash.now[:danger] = 'Unable to create page'
        render :action => :new
      end
    end

    def edit
      @page = Effective::Page.find(params[:id])
      @page_title = 'Edit Page'

      EffectivePages.authorized?(self, :edit, @page)
    end

    def update
      @page = Effective::Page.find(params[:id])
      @page_title = 'Edit Page'

      EffectivePages.authorized?(self, :update, @page)

      if @page.update_attributes(page_params)
        if params[:commit] == 'Save and Edit Content' && defined?(EffectiveRegions)
          redirect_to effective_regions.edit_path(effective_pages.page_path(@page), :exit => effective_pages.edit_admin_page_path(@page))
        elsif params[:commit] == 'Save and Add New'
          redirect_to effective_pages.new_admin_page_path
        else
          flash[:success] = 'Successfully updated page'
          redirect_to effective_pages.edit_admin_page_path(@page)
        end
      else
        flash.now[:danger] = 'Unable to update page'
        render :action => :edit
      end
    end

    def destroy
      @page = Effective::Page.find(params[:id])

      EffectivePages.authorized?(self, :destroy, @page)

      if @page.destroy
        flash[:success] = 'Successfully deleted page'
      else
        flash[:danger] = 'Unable to delete page'
      end

      redirect_to effective_pages.admin_pages_path
    end

    private

    def page_params
      params.require(:effective_page).permit(
        :title, :meta_description, :draft, :layout, :template, :slug, roles: []
      )
    end

  end
end
